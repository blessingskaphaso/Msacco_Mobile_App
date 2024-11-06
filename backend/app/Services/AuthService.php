<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class AuthService
{
    // Register User
    public function register(array $data)
    {
        try {
            $validator = Validator::make($data, [
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'phone_number' => 'required|string|max:10|unique:users',
                'password' => 'required|string|min:8|confirmed',
                // 'password' => 'required|string|min:8',
            ]);

            if ($validator->fails()) {
                return [
                    'status' => false,
                    'errors' => $validator->errors(),
                    'status_code' => 400,
                ];
            }

            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'phone_number' => $data['phone_number'],
                'password' => Hash::make($data['password']),
            ]);

            return [
                'status' => true,
                'message' => 'User registered successfully!',
                'user' => $user,
                'status_code' => 201,
            ];
        } catch (\Exception $e) {
            return [
                'status' => false,
                'message' => 'An error occurred during registration. Please try again later.',
                'error' => $e->getMessage(),
                'status_code' => 500,
            ];
        }
    }

    // Login User
    public function login(array $data)
    {
        try {
            $validator = Validator::make($data, [
                'email' => 'required|string|email',
                'password' => 'required|string',
            ]);

            if ($validator->fails()) {
                return [
                    'status' => false,
                    'errors' => $validator->errors(),
                    'status_code' => 400,
                ];
            }

            $user = User::where('email', $data['email'])->first();

            if (!$user || !Hash::check($data['password'], $user->password)) {
                return [
                    'status' => false,
                    'message' => 'Invalid credentials. Please check your email and password.',
                    'status_code' => 401,
                ];
            }

            $token = $user->createToken('Personal Access Token')->accessToken;

            return [
                'status' => true,
                'message' => 'Login successful!',
                'token' => $token,
                'user' => $user,
                'status_code' => 200,
            ];
        } catch (\Exception $e) {
            return [
                'status' => false,
                'message' => 'An error occurred during login. Please try again later.',
                'error' => $e->getMessage(),
                'status_code' => 500,
            ];
        }
    }

    // Logout User
    public function logout($userId)
    {
        try {
            $user = User::findOrFail($userId);

            // Revoke all tokens for the user
            foreach ($user->tokens as $token) {
                $token->revoke();
            }

            return [
                'status' => true,
                'message' => 'Logout successful!',
                'status_code' => 200,
            ];
        } catch (\Exception $e) {
            return [
                'status' => false,
                'message' => 'An error occurred during logout. Please try again later.',
                'error' => $e->getMessage(),
                'status_code' => 500,
            ];
        }
    }

    // Change Password
    public function changePassword(User $user, array $data)
    {
        // Check that the current password matches
        if (!Hash::check($data['current_password'], $user->password)) {
            throw ValidationException::withMessages([
                'current_password' => ['Current password is incorrect.'],
            ]);
        }

        // Update the user's password
        $user->password = Hash::make($data['new_password']);
        $user->save();

        return [
            'status' => true,
            'message' => 'Password changed successfully!',
        ];
    }
}
