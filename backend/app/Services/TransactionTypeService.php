<?php

namespace App\Services;

use App\Models\TransactionType;

class TransactionTypeService
{
    // Get all transaction types
    public function getAllTypes()
    {
        return TransactionType::all();
    }

    // Get a specific transaction type by ID
    public function getTypeById($id)
    {
        return TransactionType::find($id);
    }

    // Create a new transaction type
    public function createType($data)
    {
        return TransactionType::create($data);
    }
}
