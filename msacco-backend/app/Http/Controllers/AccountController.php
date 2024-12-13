<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AccountController extends Controller
{
    /**
     * Display a listing of all accounts.
     *
     * This endpoint is accessible to all authenticated users, returning a list
     * of all accounts in the system.
     *
     * @return \Illuminate\Http\JsonResponse JSON response containing all accounts.
     */
    public function index()
    {
        $accounts = Account::all();
        return response()->json($accounts, 200);
    }

    /**
     * Store a new account for a specified user (Admin only).
     *
     * Only an admin can create a new account for a user. The account creation is restricted
     * to users with an "Active" status who do not already hold an account. Admins themselves
     * cannot have an account created.
     *
     * @param Request $request The incoming HTTP request containing user_id and balance details.
     * @return \Illuminate\Http\JsonResponse JSON response with the created account details or an error message.
     */
    public function store(Request $request)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can create accounts.'], 403);
        }

        $request->validate([
            'user_id' => 'required|exists:users,id',
            'share_balance' => 'nullable|numeric|min:0',
            'deposit_balance' => 'nullable|numeric|min:0',
        ]);

        $user = User::find($request->user_id);

        if ($user->isAdmin()) {
            return response()->json(['message' => 'Admins cannot have accounts.'], 403);
        }

        if ($user->account) {
            return response()->json(['message' => 'User already holds an account.'], 403);
        }

        if ($user->status !== 'Active') {
            return response()->json(['message' => 'Accounts can only be created for users with an Active status.'], 403);
        }

        $account = Account::create([
            'id' => $request->user_id, // Ensure ID matches the user ID
            'user_id' => $request->user_id,
            'share_balance' => $request->share_balance ?? 0,
            'deposit_balance' => $request->deposit_balance ?? 0,
        ]);

        return response()->json($account, 201);
    }


    /**
     * Display a specific account by ID.
     *
     * Retrieves the details of an account by its ID. If the account is not found,
     * a 404 response is returned.
     *
     * @param int $id The ID of the account to retrieve.
     * @return \Illuminate\Http\JsonResponse JSON response with the account details or an error message.
     */
    public function show($id)
    {
        $account = Account::find($id);

        if (!$account) {
            return response()->json(['message' => 'Account not found.'], 404);
        }

        return response()->json($account, 200);
    }

    /**
     * Update a specific account's balances (Admin only).
     *
     * Allows an admin to update the share and deposit balances of an account.
     * Regular users do not have permission to modify account balances.
     *
     * @param Request $request The HTTP request containing the balance updates.
     * @param Account $account The account instance to update.
     * @return \Illuminate\Http\JsonResponse JSON response with the updated account or an error message.
     */
    public function update(Request $request, Account $account)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can update account balances.'], 403);
        }

        $request->validate([
            'share_balance' => 'nullable|numeric|min:0',
            'deposit_balance' => 'nullable|numeric|min:0',
        ]);

        $account->update($request->only(['share_balance', 'deposit_balance']));

        return response()->json($account, 200);
    }

    /**
     * Remove a specific account (Admin only).
     *
     * Allows an admin to delete an account. Regular users do not have permission
     * to delete accounts.
     *
     * @param Account $account The account instance to delete.
     * @return \Illuminate\Http\JsonResponse JSON response confirming deletion or an error message.
     */
    public function destroy(Account $account)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can delete accounts.'], 403);
        }

        $account->delete();
        return response()->json(['message' => 'Account deleted successfully'], 200);
    }

    /**
     * Display the logged-in user's account.
     *
     * Allows a regular user to view their own account details. Admins do not have personal accounts
     * and will receive an error if they attempt to access this endpoint.
     *
     * @return \Illuminate\Http\JsonResponse JSON response with the user's account details or an error message.
     */
    public function showUserAccount()
    {
        $user = Auth::user();

        if ($user->isAdmin()) {
            return response()->json(['message' => 'Admins do not have personal accounts.'], 403);
        }

        $account = $user->account;

        if (!$account) {
            return response()->json(['message' => 'No account found for the user'], 404);
        }

        return response()->json($account, 200);
    }
}
