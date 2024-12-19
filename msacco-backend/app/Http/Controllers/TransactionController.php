<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TransactionController extends Controller
{
/**
 * Display a listing of transactions.
 *
 * Admins can view all transactions, while regular users can only view
 * transactions for their own account.
 *
 * @return \Illuminate\Http\JsonResponse JSON response containing transactions.
 */
public function index()
{
    $user = Auth::user();

    if ($user->isAdmin()) {
        // Admin: Return all transactions
        $transactions = Transaction::all();
    } else {
        // Regular user: Return transactions for the user's account only
        $account = $user->account;

        if (!$account) {
            return response()->json(['message' => 'No account found for the user.'], 404);
        }

        $transactions = Transaction::where('account_id', $account->id)->get();
    }

    return response()->json($transactions, 200);
}


    /**
     * Store a new transaction for a specified account (Admin only).
     *
     * This method allows an admin to record a transaction for a user's account.
     * Transactions can be of type deposit, withdrawal, or loan repayment.
     * The account balance is adjusted based on the transaction type.
     * Withdrawals and loan repayments deduct from the deposit balance,
     * while deposits add to the deposit balance.
     *
     * @param Request $request HTTP request containing account_id, type, amount, source, and destination.
     * @return \Illuminate\Http\JsonResponse JSON response with the created transaction details or an error message.
     */
    public function store(Request $request)
    {
        // Validate the incoming request data
        $request->validate([
            'account_id' => 'required|exists:accounts,id',
            'type' => 'required|in:deposit,withdraw,shares,loan_repayment',
            'amount' => 'required|numeric|min:0.01',
            'source' => 'required|string|max:255',
            'destination' => 'required|string|max:255',
        ]);

        // Check if the account exists
        $account = Account::find($request->account_id);
        if (!$account) {
            return response()->json(['message' => 'Account does not exist.'], 404);
        }

        // Check if the user is associated with the account or is an admin
        $user = Auth::user();
        if ($user->id !== $account->user_id && !$user->isAdmin()) {
            return response()->json(['message' => 'Unauthorized to create transactions for this account.'], 403);
        }

        // Handle insufficient funds for withdrawals
        if ($request->type === 'withdraw' && $account->deposit_balance < $request->amount) {
            return response()->json(['message' => 'Insufficient funds for withdrawal.'], 403);
        }

        // Adjust the account balance based on the transaction type
        if ($request->type === 'deposit') {
            $account->increment('deposit_balance', $request->amount);
        } elseif ($request->type === 'withdraw' || $request->type === 'loan_repayment') {
            $account->decrement('deposit_balance', $request->amount);
        } elseif ($request->type === 'shares') {
            $account->increment('share_balance', $request->amount);
        }

        // Create the transaction
        $transaction = Transaction::create([
            'account_id' => $request->account_id,
            'type' => $request->type,
            'amount' => $request->amount,
            'source' => $request->source,
            'destination' => $request->destination,
            'transaction_date' => now(),
        ]);

        return response()->json([
            'message' => 'Transaction created successfully.',
            'transaction' => $transaction,
        ], 201);
    }


    /**
     * Display a specific transaction.
     *
     * This endpoint retrieves the details of a specific transaction by its ID.
     * Only authenticated users can access it, and they must have the proper authorization.
     *
     * @param Transaction $transaction The transaction instance retrieved by its ID.
     * @return \Illuminate\Http\JsonResponse JSON response containing the transaction details.
     */
    public function show(Transaction $transaction)
    {
        return response()->json($transaction, 200);
    }

    /**
     * Display a list of transactions for a specific account.
     *
     * Retrieves all transactions associated with a given account, sorted by the most recent first.
     * Admins can view transactions for any account, while regular users can only view
     * transactions for their own accounts.
     *
     * @param Account $account The account instance for which transactions are being retrieved.
     * @return \Illuminate\Http\JsonResponse JSON response containing the list of transactions or an error message.
     */
    public function accountTransactions(Account $account)
    {
        $user = Auth::user();

        // Only admins or the account owner can view transactions for an account
        if (!$user->isAdmin() && $user->id !== $account->user_id) {
            return response()->json(['message' => 'Unauthorized access to account transactions.'], 403);
        }

        $transactions = $account->transactions()->orderBy('created_at', 'desc')->get();

        return response()->json($transactions, 200);
    }
}
