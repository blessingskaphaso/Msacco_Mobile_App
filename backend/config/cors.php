<?php

// return [

//     /*
//     |--------------------------------------------------------------------------
//     | Cross-Origin Resource Sharing (CORS) Configuration
//     |--------------------------------------------------------------------------
//     |
//     | Here you may configure your settings for cross-origin resource sharing
//     | or "CORS". This determines what cross-origin operations may execute
//     | in web browsers. You are free to adjust these settings as needed.
//     |
//     | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
//     |
//     */

//     'paths' => ['api/*', 'sanctum/csrf-cookie'],

//     'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE'],

//     'allowed_origins' => ['https://mywebsite.com', 'https://myotherdomain.com'],

//     'allowed_origins_patterns' => [],

//     'allowed_headers' => ['Content-Type', 'X-Requested-With', 'Authorization'],

//     'exposed_headers' => ['Authorization'],

//     'max_age' => 3600,

//     'supports_credentials' => true,
    
// ];

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'], // Allow all HTTP methods (GET, POST, PUT, DELETE, etc.)

    'allowed_origins' => ['*'], // Allow all origins for development purposes

    'allowed_origins_patterns' => [], // No need for specific patterns when allowing all

    'allowed_headers' => ['*'], // Allow all headers, useful when testing

    'exposed_headers' => [], // No specific headers exposed, adjust as needed

    'max_age' => 0, // Don't cache preflight requests, which is useful during frequent changes in development

    'supports_credentials' => true, // Allow credentials (e.g., cookies, session tokens)

];

    
