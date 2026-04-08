//
//  DatabaseManager.swift
//  habitSignIn
//
//  Created by GEU on 28/03/26.
//

import SQLite3
import Foundation

class DatabaseManager {

    static let shared = DatabaseManager()
    var db: OpaquePointer?

    private init() {
        openDatabase()
        createTable()
    }

    // MARK: - Open DB
    func openDatabase() {
        let fileURL = try! FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("users.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }

    // MARK: - Create Table
    func createTable() {
        let query = """
        CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT);
        """

        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }

    // MARK: - Insert User (Signup)
    func insertUser(email: String, password: String) -> Bool {
        let query = "INSERT INTO users (email, password) VALUES (?, ?)"

        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {

            sqlite3_bind_text(stmt, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (password as NSString).utf8String, -1, nil)

            if sqlite3_step(stmt) == SQLITE_DONE {
                sqlite3_finalize(stmt)
                return true
            }
        }

        sqlite3_finalize(stmt)
        return false
    }

    // MARK: - Validate Login
    func validateUser(email: String, password: String) -> Bool {
        let query = "SELECT * FROM users WHERE email = ? AND password = ?"

        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {

            sqlite3_bind_text(stmt, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (password as NSString).utf8String, -1, nil)

            if sqlite3_step(stmt) == SQLITE_ROW {
                sqlite3_finalize(stmt)
                return true
            }
        }

        sqlite3_finalize(stmt)
        return false
    }

    // MARK: - Check Email Exists (for Forgot Password)
    func isEmailExists(email: String) -> Bool {
        let query = "SELECT * FROM users WHERE email = ?"

        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {

            sqlite3_bind_text(stmt, 1, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(stmt) == SQLITE_ROW {
                sqlite3_finalize(stmt)
                return true
            }
        }

        sqlite3_finalize(stmt)
        return false
    }

    // MARK: - Update Password
    func updatePassword(email: String, newPassword: String) -> Bool {
        let query = "UPDATE users SET password = ? WHERE email = ?"

        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {

            sqlite3_bind_text(stmt, 1, (newPassword as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(stmt) == SQLITE_DONE {
                sqlite3_finalize(stmt)
                return true
            }
        }

        sqlite3_finalize(stmt)
        return false
    }
}
