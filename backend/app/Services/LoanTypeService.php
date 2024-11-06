<?php

namespace App\Services;

use App\Models\LoanType;

class LoanTypeService
{
    // Retrieve all loan types
    public function getAllLoanTypes()
    {
        return LoanType::all();
    }

    // Retrieve a loan type by ID
    public function getLoanTypeById($id)
    {
        return LoanType::find($id);
    }

    // Create a new loan type
    public function createLoanType(array $data)
    {
        return LoanType::create($data);
    }

    // Update an existing loan type
    public function updateLoanType($id, array $data)
    {
        $loanType = LoanType::find($id);

        if (!$loanType) {
            return null;
        }

        $loanType->update($data);
        return $loanType;
    }

    // Delete a loan type
    public function deleteLoanType($id)
    {
        $loanType = LoanType::find($id);

        if (!$loanType) {
            return false;
        }

        return $loanType->delete();
    }
}
