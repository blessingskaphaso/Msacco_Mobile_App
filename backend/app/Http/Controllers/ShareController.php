<?php

namespace App\Http\Controllers;

use App\Services\ShareService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ShareController extends Controller
{
    protected $shareService;

    public function __construct(ShareService $shareService)
    {
        $this->shareService = $shareService;
    }

    // Retrieve all shares for the authenticated user
    public function index()
    {
        $user = Auth::user();
        $shares = $this->shareService->getUserShares($user->id);

        return response()->json(['shares' => $shares], 200);
    }

    // Retrieve a specific share record by ID for the authenticated user
    public function show($share_id)
    {
        $user = Auth::user();
        $share = $this->shareService->getShareById($user->id, $share_id);

        if (!$share) {
            return response()->json(['error' => 'Share not found or unauthorized access'], 404);
        }

        return response()->json(['share' => $share], 200);
    }

    // Add new shares for the authenticated user
    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0',
        ]);
    
        $user = Auth::user();
    
        // Check if the user already has shares
        if ($this->shareService->userHasShares($user->id)) {
            return response()->json(['error' => 'User already has shares. Please update the existing shares instead.'], 409);
        }
    
        $share = $this->shareService->createShare($user->id, $request->all());
    
        return response()->json(['message' => 'Share added successfully', 'share' => $share], 201);
    }
    

    // Update existing shares for the authenticated user
    public function update(Request $request, $share_id)
    {
        $request->validate([
            'amount' => 'numeric|min:0',
        ]);

        $user = Auth::user();
        $updatedShare = $this->shareService->updateShare($user->id, $share_id, $request->all());

        if (!$updatedShare) {
            return response()->json(['error' => 'Share not found or unauthorized access'], 404);
        }

        return response()->json(['message' => 'Share updated successfully', 'share' => $updatedShare], 200);
    }
}
