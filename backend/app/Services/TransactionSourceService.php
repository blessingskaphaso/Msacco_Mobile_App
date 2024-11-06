<?php

namespace App\Services;

use App\Models\TransactionSource;

class TransactionSourceService
{
    // Get all transaction sources
    public function getAllSources()
    {
        return TransactionSource::all();
    }

    // Get a specific transaction source by ID
    public function getSourceById($id)
    {
        return TransactionSource::find($id);
    }

    // Create a new transaction source
    public function createSource($data)
    {
        return TransactionSource::create($data);
    }
}
