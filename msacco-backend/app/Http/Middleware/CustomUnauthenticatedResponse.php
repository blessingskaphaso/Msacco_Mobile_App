<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Http\Request;

class CustomUnauthenticatedResponse extends Middleware
{
    protected function unauthenticated($request, array $guards)
    {
        // Return a JSON response for unauthenticated users
        return response()->json(['message' => 'User not logged in'], 401);
    }

    public function handle($request, Closure $next, ...$guards) // Remove the explicit type for $request
    {
        if ($this->auth->guard()->guest()) {
            return $this->unauthenticated($request, $guards);
        }

        return $next($request);
    }
}
