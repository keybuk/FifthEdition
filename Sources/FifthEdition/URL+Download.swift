//
//  URL+Download.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/6/26.
//

import Foundation
import Synchronization

public extension URL {
    /// Retrieve the contents of this URL into a saved file asynchronously.
    /// - Parameters:
    ///   - url: The URL to download into.
    ///   - configuration: `URLSession` configuration to use, defaults to `.default`.
    ///   - progress: Called to report download progress with total bytes written and expected as parameters.
    /// - Returns: `URLResponse`.
    func download(to url: URL, configuration _: URLSessionConfiguration = .default,
                  progress: @escaping @Sendable (Int64, Int64) -> Void = { _, _ in })
        async throws -> URLResponse?
    {
        // Wrap the delegate-style URLSession API with a checked throwing continuation to turn it into async/await.
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URLResponse?, any Error>) in
            // Construct the delegate to report progress, move the downloaded URL to the final destination before
            // URLSession cleans it up, and then complete the continuation with the response or error.
            let delegate = DownloadDelegate(progress: progress) { downloadedURL in
                try FileManager.default.moveItem(at: downloadedURL, to: url)
            } completion: { response, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: response)
                }
            }

            // Neither `URLSession.download(from:delegate:)` or `URLSession.downloadTask(with:delegate:)` actually
            // make the delegate calls we're interested in, so we need to set the delegate on `URLSession` itself.
            // To stop it holding onto the delegate beyond the lifetime of this method, invalidate the session.
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            session
                .downloadTask(with: self)
                .resume()
            session.finishTasksAndInvalidate()
        }
    }

    private final class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
        let progress: @Sendable (Int64, Int64) -> Void
        let downloaded: @Sendable (URL) throws -> Void
        let completion: @Sendable (URLResponse?, (any Error)?) -> Void

        /// Error thrown by ``downloaded`` closure.
        let error = Mutex<(any Error)?>(nil)

        init(progress: @escaping @Sendable (Int64, Int64) -> Void,
             downloaded: @escaping @Sendable (URL) throws -> Void,
             completion: @escaping @Sendable (URLResponse?, (any Error)?) -> Void)
        {
            self.progress = progress
            self.downloaded = downloaded
            self.completion = completion
        }

        func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didWriteData _: Int64,
                        totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
        {
            progress(totalBytesWritten, totalBytesExpectedToWrite)
        }

        func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
            do {
                try downloaded(url)
            } catch {
                self.error.withLock { $0 = error }
            }
        }

        func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
            if let error = self.error.withLock({ $0 }) {
                completion(nil, error)
            } else if let error {
                completion(nil, error)
            } else {
                completion(task.response, nil)
            }
        }
    }
}
