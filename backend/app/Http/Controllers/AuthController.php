<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register a new user in the system.
     * 
     * Validates the provided user data, ensures email and phone number uniqueness, 
     * and returns a JSON response with the registered user information upon success.
     * 
     * @param \Illuminate\Http\Request $request
     * 
     * @return \Illuminate\Http\JsonResponse
     * 
     * @throws ValidationException if the request fails validation
     * 
     * @bodyParam name string required The user's full name. Example: John Doe
     * @bodyParam email string required The user's unique email address. Example: johndoe@example.com
     * @bodyParam phone_number string required The user's unique phone number (max 10 characters). Example: 1234567890
     * @bodyParam password string required The user's password, must be at least 8 characters and confirmed. Example: securePassword123
     * 
     * @response 201 {
     *    "message": "User registered successfully!",
     *    "user": {
     *        "id": 1,
     *        "name": "John Doe",
     *        "email": "johndoe@example.com",
     *        "phone_number": "1234567890",
     *        "created_at": "2024-01-01T00:00:00.000000Z",
     *        "updated_at": "2024-01-01T00:00:00.000000Z"
     *    }
     * }
     * @response 422 {
     *    "message": "Validation error",
     *    "errors": {
     *        "email": ["The email address already exists."],
     *        "phone_number": ["The phone number already exists."]
     *    }
     * }
     * @response 500 {
     *    "message": "An error occurred during registration. Please try again later.",
     *    "error": "Error details message"
     * }
     */
    public function register(Request $request)
    {
        // Custom validation messages for unique fields
        $messages = [
            'email.unique' => 'The email address already exists.',
            'phone_number.unique' => 'The phone number already exists.',
            'name.required' => 'The name field is required.',
            'email.required' => 'The email field is required.',
            'phone_number.required' => 'The phone number field is required.',
            'password.required' => 'The password field is required.',
            'password.confirmed' => 'The password confirmation does not match.'
        ];

        try {
            // Validate request input with custom messages
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|unique:users,email',
                'phone_number' => 'required|string|max:10|unique:users,phone_number',
                'password' => 'required|string|min:8|confirmed'
            ], $messages);

            // Create new user
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'phone_number' => $request->phone_number,
                'password' => Hash::make($request->password)
            ]);

            return response()->json([
                'message' => 'User registered successfully!',
                'user' => $user
            ], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An error occurred during registration. Please try again later.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Login an existing user.
     * 
     * Validates credentials and returns a JSON response with a user token if successful.
     * 
     * @param \Illuminate\Http\Request $request
     * 
     * @return \Illuminate\Http\JsonResponse
     * 
     * @throws ValidationException if the request fails validation
     * 
     * @bodyParam email string required The user's email address. Example: johndoe@example.com
     * @bodyParam password string required The user's password. Example: securePassword123
     * 
     * @response 200 {
     *    "message": "Login successful!",
     *    "token": "user-authentication-token",
     *    "user": {
     *        "id": 1,
     *        "name": "John Doe",
     *        "email": "johndoe@example.com",
     *        "phone_number": "1234567890",
     *        "created_at": "2024-01-01T00:00:00.000000Z",
     *        "updated_at": "2024-01-01T00:00:00.000000Z"
     *    }
     * }
     * @response 401 {
     *    "message": "Invalid credentials. Please check your email and password."
     * }
     * @response 422 {
     *    "message": "Validation error",
     *    "errors": {
     *        "email": ["The email field is required."],
     *        "password": ["The password field is required."]
     *    }
     * }
     */
    public function login(Request $request)
    {
        // Custom validation messages for missing fields
        $messages = [
            'email.required' => 'The email field is required.',
            'password.required' => 'The password field is required.'
        ];

        try {
            // Validate request input with custom messages
            $request->validate([
                'email' => 'required|string|email',
                'password' => 'required|string'
            ], $messages);

            $user = User::where('email', $request->email)->first();

            // Check if user exists and password is correct
            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json([
                    'message' => 'Invalid credentials. Please check your email and password.'
                ], 401);
            }

            // Generate token and return response
            $tokenResult = $user->createToken('auth_token');
            $token = $tokenResult->accessToken;

            return response()->json([
                'message' => 'Login successful!',
                'token' => $token,
                'user' => $user
            ], 200);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        }
    }

    /**
     * Logout the authenticated user.
     * 
     * Deletes user tokens and returns a JSON response confirming logout.
     * 
     * @param int $id The ID of the user to log out.
     * 
     * @return \Illuminate\Http\JsonResponse
     * 
     * @response 200 {
     *    "message": "Logout successful!"
     * }
     * @response 404 {
     *    "message": "User not found"
     * }
     */
    public function logout($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        $user->tokens()->delete();
        return response()->json(['message' => 'Logout successful!'], 200);
    }

    /**
     * Change the authenticated user's password.
     * 
     * Validates the current and new passwords, ensuring the new password is unique.
     * 
     * @param \Illuminate\Http\Request $request
     * 
     * @return \Illuminate\Http\JsonResponse
     * 
     * @throws ValidationException if the request fails validation
     * 
     * @bodyParam current_password string required The current password. Example: oldPassword123
     * @bodyParam new_password string required The new password (must be different from current). Example: newPassword456
     * 
     * @response 200 {
     *    "message": "Password changed successfully"
     * }
     * @response 422 {
     *    "message": "Validation error",
     *    "errors": {
     *        "current_password": ["The current password field is required."],
     *        "new_password": ["The new password must be different from the current password."]
     *    }
     * }
     */
    public function changePassword(Request $request)
    {
        // Custom validation messages for password fields
        $messages = [
            'current_password.required' => 'The current password is required.',
            'new_password.required' => 'The new password is required.',
            'new_password.different' => 'The new password must be different from the current password.'
        ];

        try {
            // Validate request input with custom messages
            $request->validate([
                'current_password' => 'required',
                'new_password' => 'required|min:8|different:current_password'
            ], $messages);

            $user = Auth::user();

            // Check if the current password is correct
            if (!Hash::check($request->current_password, $user->password)) {
                return response()->json(['errors' => [
                    'current_password' => ['Current password is incorrect.']
                ]], 422);
            }

            // Update password
            $user->password = Hash::make($request->new_password);
            $user->save();

            return response()->json(['message' => 'Password changed successfully'], 200);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        }
    }
}
