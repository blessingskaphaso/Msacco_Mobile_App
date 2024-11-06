<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LoanController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ShareController;
use App\Http\Controllers\DepositController;
use App\Http\Controllers\DocumentController;
use App\Http\Controllers\LoanTypeController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\PersonalDetailsController;
use App\Http\Controllers\TransactionTypeController;
use App\Http\Controllers\TransactionSourceController;
use Laravel\Passport\Http\Controllers\AccessTokenController;

// Auth Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
// Logout route
Route::post('/logout/{id}', [AuthController::class, 'logout'])->middleware('auth:api');

// OAuth routes (secured by Passport middleware)
Route::group(['middleware' => 'auth:api'], function () {
    // User management routes
    Route::get('/users', [UserController::class, 'index']);
    Route::get('/users/{id}', [UserController::class, 'show']);
    Route::post('/users', [UserController::class, 'store']); // Creating a user
    Route::put('/users/{id}', [UserController::class, 'update']);
    Route::delete('/users/{id}', [UserController::class, 'destroy']);
    Route::post('/users/{id}/restore', [UserController::class, 'restore']);

    // Route to get the authenticated user's profile
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Change password route
    Route::post('/change-password', [AuthController::class, 'changePassword'])->name('auth.changePassword');



    //########################################################
    //#########     Personal Details and Documents Routes
    //########################################################

    // 1. Retrieve all personal details (with documents) for all users
    Route::get('/personal-details', [PersonalDetailsController::class, 'index'])->name('personalDetails.index');

    // 2. Retrieve personal details (with documents) for a specific user by `user_id`
    Route::get('/personal-details/{user_id}', [PersonalDetailsController::class, 'show'])->name('personalDetails.show');

    // 3. Add or update personal details for the authenticated user
    Route::post('/personal-details', [PersonalDetailsController::class, 'storeOrUpdate'])->name('personalDetails.storeOrUpdate');

    // Document-specific routes
    Route::get('/documents', [DocumentController::class, 'index'])->name('documents.index');
    Route::get('/documents/{document_id}', [DocumentController::class, 'show'])->name('documents.show');
    Route::post('/documents', [DocumentController::class, 'store'])->name('documents.store');
    // Admin-only route
    Route::get('/documents/admin', [DocumentController::class, 'adminIndex'])->name('documents.adminIndex'); 



    //########################################################
    //#########     Shares Routes
    //########################################################
    // Get all shares for the authenticated user
    Route::get('/shares', [ShareController::class, 'index'])->name('shares.index');

    // Get a specific share record by ID for the authenticated user
    Route::get('/shares/{share_id}', [ShareController::class, 'show'])->name('shares.show');

    // Add new shares for the authenticated user
    Route::post('/shares', [ShareController::class, 'store'])->name('shares.store');

    // Update existing shares for the authenticated user
    Route::put('/shares/{share_id}', [ShareController::class, 'update'])->name('shares.update');


    //########################################################
    //#########     Deposits Routes
    //########################################################
    // Get all deposits for the authenticated user
    Route::get('/deposits', [DepositController::class, 'index'])->name('deposits.index');

    // Get a specific deposit by ID for the authenticated user
    Route::get('/deposits/{deposit_id}', [DepositController::class, 'show'])->name('deposits.show');

    // Add a new deposit for the authenticated user
    Route::post('/deposits', [DepositController::class, 'store'])->name('deposits.store');

    // Update an existing deposit for the authenticated user
    Route::put('/deposits/{deposit_id}', [DepositController::class, 'update'])->name('deposits.update');


    //########################################################
    //#########     Loan Types Routes
    //########################################################
    // Retrieve all loan types
    Route::get('/loan-types', [LoanTypeController::class, 'index'])->name('loanTypes.index');

    // Retrieve a specific loan type by ID
    Route::get('/loan-types/{id}', [LoanTypeController::class, 'show'])->name('loanTypes.show');

    // Create a new loan type
    Route::post('/loan-types', [LoanTypeController::class, 'store'])->name('loanTypes.store');

    // Update an existing loan type
    Route::put('/loan-types/{id}', [LoanTypeController::class, 'update'])->name('loanTypes.update');

    // Delete a loan type
    Route::delete('/loan-types/{id}', [LoanTypeController::class, 'destroy'])->name('loanTypes.destroy');

    //########################################################
    //#########     Loan Routes
    //########################################################
    Route::get('/loans', [LoanController::class, 'index'])->name('loans.index');
    Route::get('/loans/{id}', [LoanController::class, 'show'])->name('loans.show');
    Route::post('/loans', [LoanController::class, 'store'])->name('loans.store');
    Route::patch('/loans/{id}/approve', [LoanController::class, 'approve'])->name('loans.approve');
    Route::patch('/loans/{id}/reject', [LoanController::class, 'reject'])->name('loans.reject');
    Route::patch('/loans/{id}/settle', [LoanController::class, 'settle'])->name('loans.settle');

    //########################################################
    //#########     Transaction Types Routes
    //########################################################
    Route::post('/transaction-types', [TransactionTypeController::class, 'store'])->name('transactionTypes.store');
    Route::get('/transaction-types', [TransactionTypeController::class, 'index'])->name('transactionTypes.index');
    Route::get('/transaction-types/{id}', [TransactionTypeController::class, 'show'])->name('transactionTypes.show');

    //########################################################
    //#########     Transaction Sources Routes
    //########################################################
    Route::post('/transaction-sources', [TransactionSourceController::class, 'store'])->name('transactionSources.store');
    Route::get('/transaction-sources', [TransactionSourceController::class, 'index'])->name('transactionSources.index');
    Route::get('/transaction-sources/{id}', [TransactionSourceController::class, 'show'])->name('transactionSources.show');

    //########################################################
    //#########     Transaction Routes
    //########################################################
    Route::get('/transactions', [TransactionController::class, 'index'])->name('transactions.index');
    Route::get('/transactions/{id}', [TransactionController::class, 'show'])->name('transactions.show');
    Route::post('/transactions', [TransactionController::class, 'store'])->name('transactions.store');

});
