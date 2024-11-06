<?php

namespace App\Http\Controllers;

use App\Services\AuthService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    protected $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    /**
     * Register a new user.
     * 
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     * 
     * @unauthenticated
     * 
     * @bodyParam name string required The name of the user. Max 255 characters. Example: John Doe
     * @bodyParam email string required The email of the user. Must be unique. Example: johndoe@example.com
     * @bodyParam phone_number string required The phone number of the user. Must be unique and max 10 characters. Example: 1234567890
     * @bodyParam password string required The password for the user account. Min 8 characters. Example: mySecret123
     * @bodyParam password_confirmation string required The password confirmation. Must match password. Example: mySecret123
     */
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users,email',
            'phone_number' => 'required|string|max:10|unique:users,phone_number',
            'password' => 'required|string|min:8|confirmed'
        ], [
            'email.unique' => 'The email address has already been taken.',
            'phone_number.unique' => 'The phone number has already been registered.',
            'password.confirmed' => 'Password confirmation does not match.'
        ]);

        $result = $this->authService->register($request->all());

        if (!$result['status']) {
            return response()->json(
                isset($result['errors']) ? ['errors' => $result['errors']] : ['message' => $result['message'], 'error' => $result['error']], 
                $result['status_code']
            );
        }

        return response()->json([
            'message' => $result['message'],
            'user' => $result['user']
        ], $result['status_code']);
    }

    /**
     * User login.
     * 
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     * 
     * @unauthenticated
     * 
     * @bodyParam email string required The email of the user. Example: johndoe@example.com
     * @bodyParam password string required The password of the user. Example: mySecret123
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string'
        ], [
            'email.required' => 'The email field is required.',
            'password.required' => 'The password field is required.'
        ]);

        $result = $this->authService->login($request->only('email', 'password'));

        if (!$result['status']) {
            return response()->json(['message' => $result['message']], $result['status_code']);
        }

        return response()->json([
            'message' => $result['message'],
            'token' => $result['token'],
            'user' => $result['user']
        ], $result['status_code']);
    }

    /**
     * User logout.
     * 
     * @param int $id The ID of the user to logout
     * @return \Illuminate\Http\JsonResponse
     * 
     * @authenticated
     * 
     * @urlParam id integer required The ID of the user Example: 1
     */
    public function logout($id)
    {
        $response = $this->authService->logout($id);

        return response()->json($response, $response['status_code']);
    }

    /**
     * Change user password.
     * 
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     * @throws \Illuminate\Validation\ValidationException
     * 
     * @authenticated
     * 
     * @bodyParam current_password string required The current password of the user Example: oldPass123
     * @bodyParam new_password string required The new password to set. Must be at least 8 characters Example: newSecurePass456
     */
    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|min:8|different:current_password',
        ], [
            'current_password.required' => 'The current password is required.',
            'new_password.required' => 'The new password is required.',
            'new_password.min' => 'The new password must be at least 8 characters.',
            'new_password.different' => 'The new password must be different from the current password.'
        ]);

        try {
            $this->authService->changePassword(Auth::user(), $request->only('current_password', 'new_password'));

            return response()->json(['message' => 'Password changed successfully'], 200);

        } catch (ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        }
    }
}
