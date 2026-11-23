// The log-in and sign-up screen shown when nobody is logged in. Sign-up picks a role and
// shows the username and password rules as a live checklist.
import Foundation
import SwiftUI
import SwiftData

struct AuthView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case logIn = "Log In"
        case signUp = "Sign Up"

        var id: Self { self }
    }

    let onAuthenticated: @MainActor (User) -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var mode: Mode = .logIn
    @State private var credentials = Credentials()
    @State private var errorMessage: String?
    @State private var isWorking = false

    private var canSubmit: Bool {
        mode == .logIn ? credentials.canLogIn : credentials.canSignUp
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Mode", selection: $mode) {
                        ForEach(Mode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                } footer: {
                    Text("Accounts are stored only on this device.")
                }

                if mode == .signUp {
                    Section {
                        Picker("Account type", selection: $credentials.role) {
                            ForEach(UserRole.allCases) { role in
                                Text(role.title).tag(role)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    } header: {
                        Text("Account type")
                    } footer: {
                        Text(credentials.role.summary)
                    }
                }

                Section {
                    TextField("Username", text: $credentials.username)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $credentials.password)
                        .textContentType(mode == .signUp ? .newPassword : .password)
                    if mode == .signUp {
                        SecureField("Confirm password", text: $credentials.confirmPassword)
                            .textContentType(.newPassword)
                    }
                } footer: {
                    if let errorMessage {
                        Text(errorMessage).foregroundStyle(Theme.red)
                    }
                }

                if mode == .signUp {
                    Section("Requirements") {
                        ForEach(credentials.usernameRules + credentials.passwordRules) { rule in
                            ruleRow(rule)
                        }
                    }
                }

                Section {
                    Button(action: submit) {
                        Group {
                            if isWorking {
                                ProgressView().tint(Theme.onAccent)
                            } else {
                                Text(mode.rawValue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.red)
                    .disabled(!canSubmit || isWorking)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: 420)
            .frame(maxWidth: .infinity)
            .background(Theme.background)
            .onSubmit(submit)
            .onChange(of: mode) {
                errorMessage = nil
                credentials.confirmPassword = ""
            }
            .navigationTitle("Forked")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func ruleRow(_ rule: Credentials.Rule) -> some View {
        Label {
            Text(rule.text)
        } icon: {
            Image(systemName: rule.isMet ? "checkmark.circle.fill" : "circle")
        }
        .font(.footnote)
        .foregroundStyle(rule.isMet ? Theme.text : Theme.secondaryText)
        .accessibilityElement(children: .combine)
        .accessibilityValue(rule.isMet ? "Met" : "Not met")
    }

    /// Signs up or logs in with what was typed, then reports the account to RootView.
    private func submit() {
        guard canSubmit, !isWorking else { return }
        isWorking = true
        errorMessage = nil
        // Copies, so edits made while the hash is running don't change what gets submitted.
        let credentials = credentials
        let mode = mode
        Task {
            do {
                let user: User
                if mode == .signUp {
                    user = try await User.signUp(credentials, in: modelContext)
                } else {
                    user = try await User.logIn(credentials, in: modelContext)
                }
                onAuthenticated(user)
            } catch {
                errorMessage = error.localizedDescription
            }
            isWorking = false
        }
    }
}
