<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\LoanTypeController;
use App\Http\Controllers\LoanController;
use App\Http\Controllers\TokenController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\RepaymentController;
use App\Http\Controllers\PersonalDetailController;
use App\Http\Controllers\DocumentController;
use App\Http\Controllers\ActivityLogController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\LiveChatController;
use App\Http\Controllers\LoanConfigurationController;

// Route to get authenticated user's information
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// User Routes
Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);
Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user', [UserController::class, 'showCurrentUser']); // Show current logged-in user
    Route::get('/users', [UserController::class, 'showAllUsers']);   // Show all users in the system

    Route::put('/user/update', [UserController::class, 'update']);
    Route::put('/user/change-password', [UserController::class, 'changePassword']); // Change password route
    Route::post('/logout', [UserController::class, 'logout']); // Update user details route
});


// Account Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/accounts', [AccountController::class, 'index']);
    Route::post('/accounts', [AccountController::class, 'store']);
    Route::get('/accounts/{account}', [AccountController::class, 'show']);
    Route::put('/accounts/{account}', [AccountController::class, 'update']);
    Route::delete('/accounts/{account}', [AccountController::class, 'destroy']);
});

// Loan Type Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/loan-types', [LoanTypeController::class, 'index']);
    Route::post('/loan-types', [LoanTypeController::class, 'store']);
    Route::get('/loan-types/{loanType}', [LoanTypeController::class, 'show']);
    Route::put('/loan-types/{loanType}', [LoanTypeController::class, 'update']);
    Route::delete('/loan-types/{loanType}', [LoanTypeController::class, 'destroy']);
});

// Loan Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/loans', [LoanController::class, 'index']);
    Route::post('/loans', [LoanController::class, 'store']);
    Route::get('/loans/{loan}', [LoanController::class, 'show']);
    Route::put('/loans/{loan}', [LoanController::class, 'update']);
    Route::delete('/loans/{loan}', [LoanController::class, 'destroy']);
});

// Token Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/tokens', [TokenController::class, 'index']);
    Route::post('/tokens', [TokenController::class, 'store']);
    Route::delete('/tokens/{token}', [TokenController::class, 'destroy']);
});

// Transaction Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/transactions', [TransactionController::class, 'index']);
    Route::post('/transactions', [TransactionController::class, 'store']);
    Route::get('/transactions/{transaction}', [TransactionController::class, 'show']);
    Route::delete('/transactions/{transaction}', [TransactionController::class, 'destroy']);
});

// Repayment Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/repayments', [RepaymentController::class, 'index']);
    Route::post('/repayments', [RepaymentController::class, 'store']);
    Route::get('/repayments/{repayment}', [RepaymentController::class, 'show']);
    Route::delete('/repayments/{repayment}', [RepaymentController::class, 'destroy']);
});

// Personal Details Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/personal-details', [PersonalDetailController::class, 'index']);
    Route::post('/personal-details', [PersonalDetailController::class, 'store']);
    Route::get('/personal-details/{personalDetail}', [PersonalDetailController::class, 'show']);
    Route::put('/personal-details/{personalDetail}', [PersonalDetailController::class, 'update']);
});

// Document Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/documents', [DocumentController::class, 'index']);
    Route::post('/documents', [DocumentController::class, 'store']);
    Route::get('/documents/{document}', [DocumentController::class, 'show']);
    Route::delete('/documents/{document}', [DocumentController::class, 'destroy']);
});

// Activity Log Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/activity-logs', [ActivityLogController::class, 'index']);
    Route::post('/activity-logs', [ActivityLogController::class, 'store']);
    Route::get('/activity-logs/{activityLog}', [ActivityLogController::class, 'show']);
});

// Notification Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::post('/notifications', [NotificationController::class, 'store']);
    Route::get('/notifications/{notification}', [NotificationController::class, 'show']);
    Route::put('/notifications/{notification}', [NotificationController::class, 'markAsRead']);
});

// Live Chat Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/live-chat', [LiveChatController::class, 'index']);
    Route::post('/live-chat', [LiveChatController::class, 'store']);
    Route::get('/live-chat/{chat}', [LiveChatController::class, 'show']);
});

// Loan Configuration Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/loan-configurations', [LoanConfigurationController::class, 'index']);
    Route::post('/loan-configurations', [LoanConfigurationController::class, 'store']);
    Route::get('/loan-configurations/{loanConfiguration}', [LoanConfigurationController::class, 'show']);
    Route::put('/loan-configurations/{loanConfiguration}', [LoanConfigurationController::class, 'update']);
});