<?php

namespace App\Http\Controllers;

use App\Models\LoanType;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class LoanTypeController extends Controller
{
    /**
     * Display a listing of all loan types.
     *
     * @return \Illuminate\Http\JsonResponse JSON response containing all loan types.
     */
    public function index()
    {
        $loanTypes = LoanType::all();
        return response()->json($loanTypes, 200);
    }

    /**
     * Store a new loan type (Admin only).
     *
     * Allows an admin to create a new loan type by providing a unique name, interest rate, and duration.
     * Each field is validated, and specific error messages are returned if validation fails.
     *
     * @param Request $request HTTP request containing loan type details.
     * @return \Illuminate\Http\JsonResponse JSON response with the created loan type or error message.
     */
    public function store(Request $request)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can create loan types.'], 403);
        }

        // Define validation rules and messages
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255|unique:loan_types,name',
            'interest_rate' => 'required|numeric|min:0|max:100',
            'duration' => 'required|integer|min:1',
        ], [
            'name.required' => 'The name field is required.',
            'name.string' => 'The name must be a valid string.',
            'name.max' => 'The name may not be greater than 255 characters.',
            'name.unique' => 'The loan type name must be unique.',
            'interest_rate.required' => 'The interest rate field is required.',
            'interest_rate.numeric' => 'The interest rate must be a valid number.',
            'interest_rate.min' => 'The interest rate cannot be less than 0.',
            'interest_rate.max' => 'The interest rate may not be greater than 100.',
            'duration.required' => 'The duration field is required.',
            'duration.integer' => 'The duration must be a valid integer.',
            'duration.min' => 'The duration must be at least 1 month.',
        ]);

        // Manually handle validation failures
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create the loan type after successful validation
        $loanType = LoanType::create([
            'name' => $request->name,
            'interest_rate' => $request->interest_rate,
            'duration' => $request->duration,
        ]);

        return response()->json($loanType, 201);
    }
    /**
     * Display details of a specific loan type.
     *
     * @param LoanType $loanType
     * @return \Illuminate\Http\JsonResponse JSON response containing loan type details.
     */
    public function show(LoanType $loanType)
    {
        return response()->json($loanType, 200);
    }

    /**
     * Update a specific loan type (Admin only).
     *
     * @param Request $request
     * @param LoanType $loanType
     * @return \Illuminate\Http\JsonResponse JSON response with updated loan type details or error message.
     */
    public function update(Request $request, LoanType $loanType)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can update loan types.'], 403);
        }

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'interest_rate' => 'sometimes|numeric|min:0|max:100',
            'duration' => 'sometimes|integer|min:1',
        ]);

        $loanType->update($request->only(['name', 'interest_rate', 'duration']));

        return response()->json($loanType, 200);
    }

    /**
     * Remove a specific loan type (Admin only).
     *
     * @param LoanType $loanType
     * @return \Illuminate\Http\JsonResponse JSON response confirming deletion or error message.
     */
    public function destroy(LoanType $loanType)
    {
        $admin = Auth::user();

        if (!$admin->isAdmin()) {
            return response()->json(['message' => 'Only admins can delete loan types.'], 403);
        }

        $loanType->delete();
        return response()->json(['message' => 'Loan type deleted successfully'], 200);
    }
}
