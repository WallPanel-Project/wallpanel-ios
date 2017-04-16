//
//  LoggingPrint.swift
//  From: https://gist.github.com/Abizern/a81f31a75e1ad98ff80d
//
import Foundation

/**
 Prints the filename, function name, line number and textual representation of `object` and a newline character into
 the standard output if the build setting for "Active Complilation Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`.
 The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
 Only the first parameter needs to be passed to this funtion.
 The textual representation is obtained from the `object` using `String(reflecting:)` which works for _any_ type.
 To provide a custom format for the output make your object conform to `CustomDebugStringConvertible` and provide your format in
 the `debugDescription` parameter.
 :param: object   The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
 :param: file     The name of the file, defaults to the current file without the ".swift" extension.
 :param: function The name of the function, defaults to the function within which the call is made.
 :param: line     The line number, defaults to the line number within the file that the call is made.
 */

func loggingPrint<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value))
    #endif
}
