<?php

namespace App\Http\Controllers;

use App\Services\LoanTypeService;
use Illuminate\Http\Request;

class LoanTypeController extends Controller
{
    protected $loanTypeService;

    public function __construct(LoanTypeService $loanTypeService)
    {
        $this->loanTypeService = $loanTypeService;
    }

    // Get all loan types
    public function index()
    {
        $loanTypes = $this->loanTypeService->getAllLoanTypes();
        return response()->json(['loan_types' => $loanTypes], 200);
    }

    // Get a specific loan type by ID
    public function show($id)
    {
        $loanType = $this->loanTypeService->getLoanTypeById($id);

        if (!$loanType) {
            return response()->json(['error' => 'Loan type not found'], 404);
        }

        return response()->json(['loan_type' => $loanType], 200);
    }

    // Create a new loan type
    public function store(Request $request)
    {
        // Validate the incoming request with custom messages
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'interest_rate' => 'required|numeric',
            'duration' => 'required|integer'
        ], [
            'name.required' => 'The loan type name is required.',
            'interest_rate.required' => 'The interest rate is required and must be numeric.',
            'duration.required' => 'Duration is required and must be an integer.'
        ]);
    
        // Log the validated data for debugging purposes
        \Log::info('Validated Data:', $validatedData);
    
        // Create the loan type if validation passes
        $loanType = $this->loanTypeService->createLoanType($validatedData);
    
        return response()->json(['message' => 'Loan type created successfully', 'loan_type' => $loanType], 201);
    }
    

    // Update an existing loan type
    public function update(Request $request, $id)
    {
        $request->validate([
            'name' => 'string|max:255',
            'interest_rate' => 'numeric',
            'duration' => 'integer'
        ], [
            'name.max' => 'The loan type name must not exceed 255 characters.',
            'interest_rate.numeric' => 'The interest rate must be a number.',
            'duration.integer' => 'Duration must be an integer.'
        ]);

        $updatedLoanType = $this->loanTypeService->updateLoanType($id, $request->all());

        if (!$updatedLoanType) {
            return response()->json(['error' => 'Loan type not found or update failed'], 404);
        }

        return response()->json(['message' => 'Loan type updated successfully', 'loan_type' => $updatedLoanType], 200);
    }

    // Delete a loan type
    public function destroy($id)
    {
        $deleted = $this->loanTypeService->deleteLoanType($id);

        if (!$deleted) {
            return response()->json(['error' => 'Loan type not found or deletion failed'], 404);
        }

        return response()->json(['message' => 'Loan type deleted successfully'], 200);
    }
}
