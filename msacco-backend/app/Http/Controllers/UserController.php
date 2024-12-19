<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Registers a new user in the system.
     *
     * Validates incoming request data, including name, email, password, and phone number.
     * Creates a new user with a default status of "Pending" and logs in the user immediately,
     * returning a token for subsequent requests.
     *
     * @param Request $request The incoming HTTP request.
     * @return \Illuminate\Http\JsonResponse JSON response containing user details and an auth token.
     */
    public function register(Request $request)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'phone_number' => 'required|string|max:15',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create the user
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'phone_number' => $request->phone_number,
            'status' => 'Pending', // Default status
        ]);

        // Automatically log in the user after registration
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    /**
     * Authenticates an existing user.
     *
     * Validates credentials and checks the provided email and password.
     * On successful authentication, returns the user data along with a new auth token.
     *
     * @param Request $request The incoming HTTP request.
     * @return \Illuminate\Http\JsonResponse JSON response with user details and an auth token.
     */
    public function login(Request $request)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Check if the user credentials are valid
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Invalid login credentials'], 401);
        }

        $user = Auth::user();

        // Generate a new Sanctum token
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Logged in successfully',
            'user' => $user,
            'token' => $token,
        ], 200);
    }

    /**
     * Updates a specific user's details by user ID.
     *
     * Allows modification of user details such as name, email, and phone number.
     * Only admin users can modify "status" and "role". Authenticated users can update
     * their own information, but only admins can modify details of other users.
     *
     * @param Request $request The incoming HTTP request.
     * @return \Illuminate\Http\JsonResponse JSON response indicating success or failure.
     */
    public function update(Request $request)
    {
        // Validate the incoming data
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id', // Ensure user_id exists
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:users,email,' . $request->user_id,
            'phone_number' => 'sometimes|string|max:15',
            'status' => 'sometimes|in:Pending,Active,Paused', // Allowed status values
            'role' => 'sometimes|in:admin,member', // Adjust validation based on role options
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Find the user by user_id
        $user = User::find($request->user_id);

        // Check if the authenticated user is the same as the user being updated or an admin
        $isSelfUpdate = Auth::id() === $user->id;
        $isAdmin = Auth::user()->isAdmin();

        // Restrict non-admins from updating 'status' and 'role'
        if (!$isAdmin && !$isSelfUpdate) {
            return response()->json(['message' => 'Unauthorized action'], 403);
        }

        // Prepare data for updating based on permissions
        $updateData = $request->only(['name', 'email', 'phone_number']);

        // Allow admin to update status and role
        if ($isAdmin) {
            if ($request->has('status')) {
                $updateData['status'] = $request->status;
            }
            if ($request->has('role')) {
                $updateData['role'] = $request->role;
            }
        }

        // Update the user details
        $user->update($updateData);

        return response()->json([
            'message' => 'User details updated successfully',
            'user' => $user
        ], 200);
    }


    /**
     * Changes the password for a specific user by user ID.
     *
     * Allows authenticated users to change their own password, requiring the current password.
     * Admins can change any user's password without providing the current password.
     *
     * @param Request $request The incoming HTTP request.
     * @return \Illuminate\Http\JsonResponse JSON response indicating password change success or errors.
     */
    public function changePassword(Request $request)
    {
        // Validate the incoming data
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id', // Ensure user_id exists
            'current_password' => 'required_if:isAdmin,false|string|min:8', // Only required for non-admin users
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Find the user by user_id
        $user = User::find($request->user_id);

        // Check if the authenticated user has permission to change this user's password
        $isSelf = Auth::id() === $user->id;
        $isAdmin = Auth::user()->isAdmin();

        if (!$isSelf && !$isAdmin) {
            return response()->json(['message' => 'Unauthorized action'], 403);
        }

        // Verify the current password for non-admin users
        if (!$isAdmin && !Hash::check($request->current_password, $user->password)) {
            return response()->json(['message' => 'Current password is incorrect'], 403);
        }

        // Update the password
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Password changed successfully'], 200);
    }



    /**
     * Retrieves details of the currently authenticated user.
     *
     * Returns the full user profile of the logged-in user.
     *
     * @return \Illuminate\Http\JsonResponse JSON response containing the user's details.
     */
    public function showCurrentUser()
    {
        $user = Auth::user();
        return response()->json([
            'user' => $user
        ], 200);
    }

   /**
     * Retrieves a list of all users in the system.
     *
     * Restricted to admin users only. Returns the complete list of users with their details.
     *
     * @return \Illuminate\Http\JsonResponse JSON response containing an array of all users.
     */
    public function showAllUsers()
    {
        // Optional: Restrict access to admins only
        if (!Auth::user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized access'], 403);
        }

        $users = User::all();
        return response()->json([
            'users' => $users
        ], 200);
    }


    /**
     * Logs out the authenticated user by revoking their current token.
     *
     * Deletes the token associated with the current session, ending the user's login session.
     *
     * @param Request $request The incoming HTTP request.
     * @return \Illuminate\Http\JsonResponse JSON response confirming logout.
     */
    public function logout(Request $request)
    {
        // Revoke the token of the currently authenticated user
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Successfully logged out.'
        ], 200);
    }
}

