<?php

use Dedoc\Scramble\Http\Middleware\RestrictedDocsAccess;

return [
    /*
     * Your API path. By default, all routes starting with this path will be added to the docs.
     * If you need to change this behavior, you can add your custom routes resolver using `Scramble::routes()`.
     */
    'api_path' => 'api',

    /*
     * Your API domain. By default, app domain is used. This is also a part of the default API routes
     * matcher, so when implementing your own, make sure you use this config if needed.
     */
    'api_domain' => null,

    /*
     * The path where your OpenAPI specification will be exported.
     */
    'export_path' => 'api.json',

    'info' => [
        /*
         * API version.
         */
        'version' => env('API_VERSION', '0.0.1'),

        /*
         * Description rendered on the home page of the API documentation (`/docs/api`).
         */
        'description' => '
        **Msacco API** enables a robust backend system for handling cooperative financial services, such as loans, funds transfers, and transaction management. Designed for transparency, security, and ease of use, Msacco API offers these primary functions:
        
        ### Key Functionalities
        **User Management**: Streamline user onboarding and secure authentication, providing session-based user access.
        - **Registration & Authentication**: Simple onboarding and secure token-based access.
        - **Profile Management**: Flexible options for updating passwords and account details.

        **Loan Management**: Comprehensive workflow for applying, approving, and repaying loans.
        - **Application & Approval**: Eligibility-based applications, with an admin-driven approval process.
        - **Repayments**: Integrated repayment records updating both loan statuses and user balances.

        **Transaction Handling**:
        - **Transfers & History**: In-depth fund transfer options between accounts, with categories like Deposits, Shares, and Mobile Money.
        - **Transaction Sources**: Organized sources for tracking funds (e.g., Bank, Airtel Money) ensure accurate record-keeping.
        
        **Audit Logs & Security**:
        - **Transaction Logs**: Immutable logging of all user actions ensures accountability.
        - **Role-based Access**: Sensitive endpoints like loan approvals are role-restricted.
        
        ### Technology Stack
        - **Framework**: Laravel, optimized for RESTful APIs.
        - **Database**: MySQL, with dedicated tables for user roles, transactions, loans, and logs.
        - **Authentication**: OAuth-based token security.
        - **Documentation**: Auto-generated and Swagger-compatible for developer ease.

        ### Scenarios and Benefits
        - **Loan Application**: Members apply for loans, undergo eligibility checks, and, if approved, receive loan disbursements.
        - **Fund Transfers**: User fund transfers with source and destination restrictions for operational control.
        - **Audit Compliance**: Transparent record logs for transactions, approvals, and fund sources support organizational accountability.
        
        Msacco API centralizes financial functions within a cooperative, providing a secure, reliable, and user-friendly backend system.
        ',
    ],

    /*
     * Customize Stoplight Elements UI
     */
    'ui' => [
        /*
         * Define the title of the documentation's website. App name is used when this config is `null`.
         */
        'title' => 'Msacco API Documentation',

        /*
         * Define the theme of the documentation. Available options are `light` and `dark`.
         */
        'theme' => 'light',

        /*
         * Hide the `Try It` feature. Enabled by default.
         */
        'hide_try_it' => false,

        /*
         * URL to an image that displays as a small square logo next to the title, above the table of contents.
         */
        'logo' => '/logo.png',

        /*
         * Use to fetch the credential policy for the Try It feature. Options are: omit, include (default), and same-origin
         */
        'try_it_credentials_policy' => 'include',
    ],

    /*
     * The list of servers of the API. By default, when `null`, server URL will be created from
     * `scramble.api_path` and `scramble.api_domain` config variables. When providing an array, you
     * will need to specify the local server URL manually (if needed).
     */
    'servers' => null,

    'middleware' => [
        'web',
        RestrictedDocsAccess::class,
    ],

    'extensions' => [],
];
