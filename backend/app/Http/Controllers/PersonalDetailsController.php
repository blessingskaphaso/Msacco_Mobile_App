<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\PersonalInformation;
use Illuminate\Validation\ValidationException;

class PersonalDetailsController extends Controller
{
    /**
     * Retrieve all personal information records.
     *
     * @return \Illuminate\Http\JsonResponse
     *
     * @response 200 scenario="Success" {
     *     "personal_information": [
     *         {
     *             "id": 1,
     *             "user_id": 1,
     *             "home_address": "1234 Main Street",
     *             "next_of_kin_name": "Jane Doe",
     *             "next_of_kin_contact": "0123456789",
     *             "relationship": "sister",
     *             "employment_status": "Employed",
     *             "employer_name": "ABC Corp",
     *             "position": "Manager",
     *             "date_of_birth": "1990-01-01",
     *             "created_at": "2024-01-01T00:00:00.000000Z",
     *             "updated_at": "2024-01-01T00:00:00.000000Z"
     *         }
     *     ]
     * }
     * @response 500 scenario="Server Error" {
     *     "error": "An error occurred while fetching personal information."
     * }
     */
    public function index()
    {
        try {
            $personalInfo = PersonalInformation::all();
            return response()->json(['personal_information' => $personalInfo], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred while fetching personal information.'], 500);
        }
    }

    /**
     * Create or update a personal details record for a user.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     *
     * @bodyParam user_id integer required The ID of the user.
     * @bodyParam home_address string required The home address of the user. Example: 1234 Main Street
     * @bodyParam next_of_kin_name string required The name of the next of kin. Example: Jane Doe
     * @bodyParam next_of_kin_contact string required The contact number of the next of kin. Example: 0123456789
     * @bodyParam relationship string required The relationship to the next of kin. Example: Sister
     * @bodyParam employment_status string required The employment status of the user. Example: Employed
     * @bodyParam employer_name string nullable The name of the user's employer. Example: ABC Corp
     * @bodyParam position string nullable The position of the user in their job. Example: Manager
     * @bodyParam date_of_birth date required The date of birth of the user. Example: 1990-01-01
     *
     * @response 201 scenario="Success" {
     *     "message": "Personal information saved successfully.",
     *     "personal_information": {
     *         "id": 1,
     *         "user_id": 1,
     *         "home_address": "1234 Main Street",
     *         "next_of_kin_name": "Jane Doe",
     *         "next_of_kin_contact": "0123456789",
     *         "relationship": "sister",
     *         "employment_status": "Employed",
     *         "employer_name": "ABC Corp",
     *         "position": "Manager",
     *         "date_of_birth": "1990-01-01",
     *         "created_at": "2024-01-01T00:00:00.000000Z",
     *         "updated_at": "2024-01-01T00:00:00.000000Z"
     *     }
     * }
     * @response 422 scenario="Validation Error" {
     *     "message": "Validation error",
     *     "errors": {
     *         "user_id": ["The user id field is required."],
     *         "home_address": ["The home address field is required."]
     *     }
     * }
     * @response 500 scenario="Server Error" {
     *     "message": "An unexpected error occurred while saving personal information."
     * }
     */
    public function storeOrUpdate(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'user_id' => 'required|integer|exists:users,id',
                'home_address' => 'required|string|max:255',
                'next_of_kin_name' => 'required|string|max:255',
                'next_of_kin_contact' => 'required|string|max:15',
                'relationship' => 'required|string|max:50',
                'employment_status' => 'required|string|max:50',
                'employer_name' => 'nullable|string|max:255',
                'position' => 'nullable|string|max:255',
                'date_of_birth' => 'required|date',
            ]);

            $personalInfo = PersonalInformation::updateOrCreate(
                ['user_id' => $validatedData['user_id']],
                $validatedData
            );

            return response()->json([
                'message' => 'Personal information saved successfully.',
                'personal_information' => $personalInfo
            ], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred while saving personal information.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Show a specific personal information record.
     *
     * @param int $id The ID of the personal information record.
     * @return \Illuminate\Http\JsonResponse
     *
     * @urlParam id integer required The ID of the personal information record. Example: 1
     * 
     * @response 200 scenario="Success" {
     *     "personal_information": {
     *         "id": 1,
     *         "user_id": 1,
     *         "home_address": "1234 Main Street",
     *         "next_of_kin_name": "Jane Doe",
     *         "next_of_kin_contact": "0123456789",
     *         "relationship": "sister",
     *         "employment_status": "Employed",
     *         "employer_name": "ABC Corp",
     *         "position": "Manager",
     *         "date_of_birth": "1990-01-01",
     *         "created_at": "2024-01-01T00:00:00.000000Z",
     *         "updated_at": "2024-01-01T00:00:00.000000Z"
     *     }
     * }
     * @response 404 scenario="Not Found" {
     *     "message": "Personal information not found."
     * }
     * @response 500 scenario="Server Error" {
     *     "message": "An error occurred while fetching personal information."
     * }
     */
    public function show($id)
    {
        try {
            $personalInfo = PersonalInformation::findOrFail($id);
            return response()->json(['personal_information' => $personalInfo], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['message' => 'Personal information not found.'], 404);
        } catch (\Exception $e) {
            return response()->json(['message' => 'An error occurred while fetching personal information.'], 500);
        }
    }

    /**
     * Delete a personal information record.
     *
     * @param int $id The ID of the personal information record.
     * @return \Illuminate\Http\JsonResponse
     *
     * @urlParam id integer required The ID of the personal information record. Example: 1
     *
     * @response 200 scenario="Success" {
     *     "message": "Personal information deleted successfully."
     * }
     * @response 404 scenario="Not Found" {
     *     "message": "Personal information not found."
     * }
     * @response 500 scenario="Server Error" {
     *     "message": "An error occurred while deleting personal information."
     * }
     */
    public function destroy($id)
    {
        try {
            $personalInfo = PersonalInformation::findOrFail($id);
            $personalInfo->delete();
            return response()->json(['message' => 'Personal information deleted successfully.'], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json(['message' => 'Personal information not found.'], 404);
        } catch (\Exception $e) {
            return response()->json(['message' => 'An error occurred while deleting personal information.'], 500);
        }
    }
}
