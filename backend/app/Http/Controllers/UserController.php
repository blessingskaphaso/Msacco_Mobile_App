<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Get all users.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            $users = User::all();
            return response()->json(['users' => $users], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while fetching users'], 500);
        }
    }

    /**
     * Show a single user.
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        try {
            $user = User::findOrFail($id);
            return response()->json(['user' => $user], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while fetching the user'], 500);
        }
    }

    /**
     * Store a new user.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        // Validate request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users,email',
            'phone_number' => 'required|string|max:10|unique:users,phone_number',
            'password' => 'required|string|min:8'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            // Create user with validated data
            $user = User::create($request->all());
            return response()->json(['message' => 'User created successfully', 'user' => $user], 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while creating the user'], 500);
        }
    }

    /**
     * Update an existing user.
     *
     * @param \Illuminate\Http\Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        // Validate request data
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|unique:users,email,' . $id,
            'phone_number' => 'sometimes|string|max:10|unique:users,phone_number,' . $id,
            'password' => 'sometimes|string|min:8'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            // Find user and update with validated data
            $user = User::findOrFail($id);
            $user->update($request->all());
            return response()->json(['message' => 'User updated successfully', 'user' => $user], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while updating the user'], 500);
        }
    }

    /**
     * Soft delete a user.
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        try {
            $user = User::findOrFail($id);
            $user->delete();
            return response()->json(['message' => 'User deleted successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while deleting the user'], 500);
        }
    }

    /**
     * Restore a soft-deleted user.
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function restore($id)
    {
        try {
            $user = User::withTrashed()->findOrFail($id);
            $user->restore();
            return response()->json(['message' => 'User restored successfully', 'user' => $user], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while restoring the user'], 500);
        }
    }
}
