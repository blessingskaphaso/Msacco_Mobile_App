<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MSACCO - Supporting Your Business</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* Custom Scrollbar Styling */
        ::-webkit-scrollbar {
            width: 10px;
            padding: 2px 5px;
        }

        ::-webkit-scrollbar-thumb {
            background-color: #14532d;
            border-radius: 50%;
        }

        ::-webkit-scrollbar-track {
            background-color: rgba(174, 255, 158, 0.849);
            border-radius: 50%;
        }

        ::-webkit-scrollbar-track:hover {
            background-color: rgba(0, 146, 61, 0.8);
            border-radius: 50%;
        }

        /* For other browsers, fallback options can be added */
        * {
            scrollbar-width: thin;
            scrollbar-color: rgba(116, 255, 88, 0.5) #14532d;
            scroll-padding: 5px;
        }
    </style>

</head>

<body class="font-sans antialiased">
    <!-- Header Section with Navigation -->
    <header class="fixed top-0 left-0 z-50 w-full text-white bg-green-900 shadow-lg">
        <div class="container flex items-center justify-between p-4 mx-auto">
            <!-- Logo -->
            <div class="flex items-center gap-2 text-2xl font-bold">
                <img src="images/logo.png" alt="Logo" class="w-auto h-10">
                MSACCO
            </div>
            <!-- Navigation Links -->
            <nav class="hidden space-x-6 lg:flex">
                <a href="#home" class="transition duration-300 hover:text-green-300">Home</a>
                <a href="#about" class="transition duration-300 hover:text-green-300">About</a>
                <a href="#services" class="transition duration-300 hover:text-green-300">Services</a>
                <a href="#resources" class="transition duration-300 hover:text-green-300">Get Started</a>
                <a href="#developer" class="transition duration-300 hover:text-green-300">Developer</a>
                <a href="#contact" class="transition duration-300 hover:text-green-300">Contact</a>
            </nav>
            <!-- Mobile Menu Button -->
            <div class="lg:hidden">
                <button id="menu-toggle" class="text-3xl">
                    <i class="fa fa-bars"></i>
                </button>
            </div>
        </div>
        <!-- Mobile Menu -->
        <div id="mobile-menu" class="hidden w-full px-5 py-4 space-y-3 text-white lg:hidden bg-armyGreen">
            <a href="#home" class="transition duration-300 hover:text-green-300">Home</a>
            <a href="#about" class="transition duration-300 hover:text-green-300">About</a>
            <a href="#services" class="transition duration-300 hover:text-green-300">Services</a>
            <a href="#resources" class="transition duration-300 hover:text-green-300">Get Started</a>
            <a href="#developer" class="transition duration-300 hover:text-green-300">Developer</a>
            <a href="#contact" class="transition duration-300 hover:text-green-300">Contact</a>
        </div>
    </header>


    <!-- Hero Section -->
    <!-- Hero Slider Section -->
    <section id="home" class="relative flex items-center justify-center w-full h-screen overflow-hidden text-center text-white">
        <!-- Slider Container -->
        <div id="slider" class="absolute inset-0 z-0 flex transition-opacity duration-1000 ease-in-out">
            <!-- Slide 1 -->
            <div class="absolute w-full h-full transition-opacity duration-1000 ease-in-out bg-center bg-cover opacity-100 hero-slide"
                style="background-image: url('images/loan.jpg'); background-size: cover;">
                <!-- Black Overlay with Blur -->
                <div class="absolute inset-0 z-10 bg-black opacity-70 backdrop-blur-md"></div>
                <!-- Content -->
                <div class="px-[5%] relative z-20 flex flex-col items-center justify-center h-full">
                    <h1 class="text-5xl font-bold">Welcome to the MSACCO Project</h1>
                    <p class="mt-4 text-xl">Empowering communities through accessible financial services, offering loans, deposits, and more with simplicity and security.</p>
                    <button class="px-6 py-3 mt-6 transition bg-green-900 rounded-lg hover:bg-green-600">Get Started</button>
                </div>
            </div>

            <!-- Slide 2 -->
            <div class="absolute w-full h-full transition-opacity duration-1000 ease-in-out bg-center bg-cover opacity-0 hero-slide"
                style="background-image: url('images/1.jpg'); background-size: cover;">
                <!-- Black Overlay with Blur -->
                <div class="absolute inset-0 z-10 bg-black opacity-70 backdrop-blur-md"></div>
                <!-- Content -->
                <div class="px-[5%] relative z-20 flex flex-col items-center justify-center h-full">
                    <h1 class="text-5xl font-bold">Get Loans Easily with MSACCO</h1>
                    <p class="mt-4 text-xl">We provide flexible loan options to support you during financial uncertainty.</p>
                    <button class="px-6 py-3 mt-6 transition bg-green-900 rounded-lg hover:bg-green-600">Apply Now</button>
                </div>
            </div>

            <!-- Slide 3 -->
            <div class="absolute w-full h-full transition-opacity duration-1000 ease-in-out bg-center bg-cover opacity-0 hero-slide"
                style="background-image: url('images/2.jpg'); background-size: cover;">
                <!-- Black Overlay with Blur -->
                <div class="absolute inset-0 z-10 bg-black opacity-70 backdrop-blur-md"></div>
                <!-- Content -->
                <div class="px-[5%] relative z-20 flex flex-col items-center justify-center h-full">
                    <h1 class="text-5xl font-bold">Grow Your Savings with MSACCO</h1>
                    <p class="mt-4 text-xl">Join thousands of users who have saved for a brighter financial future.</p>
                    <button class="px-6 py-3 mt-6 transition bg-green-900 rounded-lg hover:bg-green-600">Join Us</button>
                </div>
            </div>
        </div>

        <!-- Circle Indicators -->
        <div class="absolute z-30 flex space-x-4 transform -translate-x-1/2 bottom-10 left-1/2">
            <button class="w-3 h-3 bg-gray-500 rounded-full hero-indicator" data-index="0"></button>
            <button class="w-3 h-3 bg-gray-500 rounded-full hero-indicator" data-index="1"></button>
            <button class="w-3 h-3 bg-gray-500 rounded-full hero-indicator" data-index="2"></button>
        </div>

        <!-- Navigation Arrows -->
        <button id="prevSlide" class="z-30 hidden p-2 text-white transform -translate-y-1/2 bg-green-900 rounded-full lg:block lg:absolute top-1/2 left-5 hover:bg-green-600">
            <i class="fas fa-chevron-left"></i>
        </button>
        <button id="nextSlide" class="z-30 hidden p-2 text-white transform -translate-y-1/2 bg-green-900 rounded-full lg:block lg:absolute top-1/2 right-5 hover:bg-green-600">
            <i class="fas fa-chevron-right"></i>
        </button>
    </section>

    <!-- Slider Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const slides = document.querySelectorAll('.hero-slide');
            const indicators = document.querySelectorAll('.hero-indicator');
            let currentIndex = 0;

            function updateIndicators(index) {
                indicators.forEach((indicator, idx) => {
                    indicator.classList.toggle('bg-green-500', idx === index);
                    indicator.classList.toggle('bg-gray-500', idx !== index);
                });
            }

            function showSlide(index) {
                slides[currentIndex].classList.remove('opacity-100');
                slides[currentIndex].classList.add('opacity-0');
                slides[index].classList.remove('opacity-0');
                slides[index].classList.add('opacity-100');
                currentIndex = index;
                updateIndicators(currentIndex);
            }

            function showNextSlide() {
                const nextIndex = (currentIndex + 1) % slides.length;
                showSlide(nextIndex);
            }

            function showPrevSlide() {
                const prevIndex = (currentIndex - 1 + slides.length) % slides.length;
                showSlide(prevIndex);
            }

            document.getElementById('nextSlide').addEventListener('click', showNextSlide);
            document.getElementById('prevSlide').addEventListener('click', showPrevSlide);

            indicators.forEach(indicator => {
                indicator.addEventListener('click', () => {
                    const index = parseInt(indicator.getAttribute('data-index'));
                    showSlide(index);
                });
            });

            // Auto slide every 5 seconds
            setInterval(showNextSlide, 5000);
        });
    </script>


    <!-- Company Section -->
    <section id="about" class="py-16 text-center bg-gray-100">
        <div class="container px-4 mx-auto">
            <h2 class="text-4xl font-bold text-armyGreen">About MSACCO</h2>
            <p class="mt-4 text-gray-600">MSACCO is here to empower communities through accessible financial services, providing flexible loans, secure deposits, and easy management of shares.</p>

            <div class="flex flex-col items-center justify-center gap-10 mt-10 md:flex-row">
                <div class="w-full max-w-md bg-green-900 md:w-1/2">
                    <img src="images/logo.png" alt="About MSACCO Image" class="w-auto rounded-lg shadow-lg h-1/2">
                </div>
                <div class="w-full text-left md:w-1/2">
                    <h3 class="text-2xl font-bold text-armyGreen">Our Mission</h3>
                    <p class="mt-4 text-gray-600">
                        MSACCO aims to make financial services accessible to all, empowering people with tools to manage their finances efficiently. We believe in fostering growth through innovation, security, and transparency.
                    </p>
                    <ul class="mt-6 space-y-3">
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-check-circle text-armyGreen"></i>Community Empowerment
                        </li>
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-check-circle text-armyGreen"></i>Financial Inclusion for All
                        </li>
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-check-circle text-armyGreen"></i>Secure and User-Friendly Solutions
                        </li>
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-check-circle text-armyGreen"></i>24/7 Technical Support
                        </li>
                    </ul>
                    <button class="px-6 py-3 mt-6 text-white transition bg-green-900 rounded-lg hover:bg-green-600">Contact Us</button>
                </div>
            </div>
        </div>
    </section>




    <!-- Services Section -->
    <section id="services" class="container px-4 py-16 mx-auto">
        <h2 class="text-4xl font-bold text-center text-armyGreen">Our Awesome Services</h2>
        <p class="mt-4 text-lg text-center text-gray-600">Empowering you with the best financial services</p>

        <div class="grid grid-cols-1 gap-8 mt-10 md:grid-cols-2 lg:grid-cols-4">
            <!-- Loans Service -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-money-check-alt text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Loans</h3>
                <p class="text-gray-500">Get flexible loans to support you during financial uncertainty with easy repayment options.</p>
            </div>

            <!-- Deposits Service -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-piggy-bank text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Deposits</h3>
                <p class="text-gray-500">Save your money securely and earn interest with our easy-to-manage deposit accounts.</p>
            </div>

            <!-- Shares Management -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-chart-line text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Shares Management</h3>
                <p class="text-gray-500">Manage your shares effectively with full transparency, giving you a sense of ownership.</p>
            </div>

            <!-- Fund Transfers Service -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-exchange-alt text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Fund Transfers</h3>
                <p class="text-gray-500">Easily transfer funds between accounts and to external financial institutions with our secure platform.</p>
            </div>

            <!-- Support Service -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-headset text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Customer Support</h3>
                <p class="text-gray-500">Our dedicated support team is available to help you resolve issues and answer your questions.</p>
            </div>

            <!-- Savings Service -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-coins text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Savings</h3>
                <p class="text-gray-500">Open a savings account to secure your future and achieve your financial goals with ease.</p>
            </div>

            <!-- Investment Planning -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-lightbulb text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Investment Planning</h3>
                <p class="text-gray-500">Get expert guidance on managing your savings and investments to maximize your returns.</p>
            </div>

            <!-- Digital Wallet -->
            <div class="p-6 text-center bg-white rounded-lg shadow-md">
                <i class="mb-4 text-4xl fas fa-wallet text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-semibold">Digital Wallet</h3>
                <p class="text-gray-500">Access your money easily, make payments, and manage finances conveniently using our digital wallet.</p>
            </div>
        </div>
    </section>

    <!-- Resources Section -->
    <section id="resources" class="container px-4 py-16 mx-auto text-center bg-white">
        <h2 class="text-4xl font-bold">Get Started with MSACCO</h2>
        <p class="mt-4 text-lg text-gray-600">
            Download our Android app, check the system documentation, or visit the admin panel for more control.
        </p>

        <div class="flex flex-col items-center justify-around gap-8 mt-10 lg:flex-row">
            <!-- Download Android App -->
            <div class="w-full max-w-xs p-6 transition border rounded-lg shadow lg:w-1/3 hover:shadow-lg">
                <i class="mb-4 text-5xl fab fa-android text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-bold text-armyGreen">Download Android App</h3>
                <p class="mb-4 text-gray-600">
                    Get the MSACCO app on your Android device and stay connected with your finances on the go.
                </p>
                <a href="#" class="inline-block px-6 py-3 text-white transition bg-green-900 rounded-lg hover:bg-green-600">
                    Download Now
                </a>
            </div>

            <!-- Visit Documentation -->
            <div class="w-full max-w-xs p-6 transition border rounded-lg shadow lg:w-1/3 hover:shadow-lg">
                <i class="mb-4 text-5xl fas fa-book text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-bold text-armyGreen">Visit Documentation</h3>
                <p class="mb-4 text-gray-600">
                    Need help? Visit our complete documentation to learn how to use MSACCO efficiently.
                </p>
                <a href="/docs/api" class="inline-block px-6 py-3 text-white transition bg-green-900 rounded-lg hover:bg-green-600">
                    Read Docs
                </a>
            </div>

            <!-- Visit Admin Panel -->
            <div class="w-full max-w-xs p-6 transition border rounded-lg shadow lg:w-1/3 hover:shadow-lg">
                <i class="mb-4 text-5xl fas fa-user-shield text-armyGreen"></i>
                <h3 class="mb-2 text-2xl font-bold text-armyGreen">Visit Admin Panel</h3>
                <p class="mb-4 text-gray-600">
                    Access the admin panel for more control and management of the MSACCO platform.
                </p>
                <a href="#" class="inline-block px-6 py-3 text-white transition bg-green-900 rounded-lg hover:bg-green-600">
                    Go to Admin
                </a>
            </div>
        </div>
    </section>


    <!-- Developer Section -->
    <section id="developer" class="container px-4 py-16 mx-auto text-center bg-gray-100">
        <h2 class="text-4xl font-bold text-armyGreen">About the Developer</h2>
        <p class="mt-4 text-lg text-gray-600">Meet the mind behind MSACCO - bringing innovation and dedication to every project.</p>

        <div class="flex flex-col items-center justify-between gap-10 mt-10 md:flex-row">
            <!-- Developer Photo -->
            <div class="w-full max-w-xs md:w-1/3">
                <img src="images/peter.jpeg" alt="Developer Photo" class="w-full h-auto rounded-md shadow-lg">
            </div>

            <!-- Developer Info -->
            <div class="flex justify-between w-full gap-8 text-left">
                <div class="w-1/2">
                    <h3 class="w-1/2 text-3xl font-bold">Blessings Peter Khapatso</h3>
                    <p class="mt-4 text-gray-600">
                        Blessings Peter Khapatso is a passionate software developer with expertise in Flutter, Laravel, and system architecture design.
                        He has been dedicated to building secure, scalable, and user-friendly solutions like MSACCO.
                        His goal is to innovate solutions that impact communities positively and efficiently.
                    </p>
                    <p class="mt-4 text-gray-600">
                        With a background in full-stack development, John has worked on numerous projects involving mobile and web applications.
                        He loves to keep the code clean, optimize performance, and provide the best user experience.
                    </p>

                    <!-- Contact Developer -->
                    <div class="mt-8">
                        <button class="px-6 py-3 text-white transition bg-green-900 rounded-lg hover:bg-green-600">
                            Contact Developer
                        </button>
                    </div>
                </div>

                <!-- Developer Skills -->
                <div class="w-1/3">
                    <h4 class="mt-6 text-2xl font-semibold text-armyGreen">Key Skills</h4>
                    <ul class="mt-4 space-y-3 text-gray-600">
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-code text-armyGreen"></i> Flutter & Dart Development
                        </li>
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-server text-armyGreen"></i> Laravel & Backend API Integration
                        </li>
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-lock text-armyGreen"></i> Secure Authentication Systems
                        </li>
                        <li class="flex items-center">
                            <i class="mr-3 text-xl fas fa-laptop-code text-armyGreen"></i> Full-stack Web & Mobile Development
                        </li>
                    </ul>

                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-16 bg-gray-100">
        <div class="container px-4 mx-auto">
            <h2 class="text-4xl font-bold text-center text-armyGreen">Get In Touch with Us</h2>
            <p class="mt-4 text-lg text-center text-gray-600">Have any questions or need assistance? We're here to help!</p>

            <div class="flex flex-col items-center justify-center gap-10 mt-10 md:flex-row">
                <!-- Contact Form -->
                <div class="w-full p-6 bg-white rounded-lg shadow-lg">
                    <form action="#">
                        <div class="mb-4">
                            <label for="name" class="block mb-2 font-bold text-gray-700">Name</label>
                            <input type="text" id="name" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-armyGreen" required>
                        </div>
                        <div class="mb-4">
                            <label for="email" class="block mb-2 font-bold text-gray-700">Email</label>
                            <input type="email" id="email" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-armyGreen" required>
                        </div>
                        <div class="mb-4">
                            <label for="message" class="block mb-2 font-bold text-gray-700">Message</label>
                            <textarea id="message" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-armyGreen" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="px-6 py-3 mt-4 text-white transition bg-green-900 rounded-lg hover:bg-green-600">Send Message</button>
                    </form>
                </div>

                <!-- Contact Information -->
                <div class="w-full max-w-md text-left">
                    <h3 class="text-2xl font-bold text-armyGreen">Our Contact Details</h3>
                    <p class="mt-4 text-gray-600">Reach out to us through any of the contact methods below.</p>
                    <div class="mt-6 space-y-4">
                        <div class="flex items-center">
                            <i class="mr-3 text-xl fas fa-map-marker-alt text-armyGreen"></i>
                            <p>123 Main Street, Lilongwe, Malawi</p>
                        </div>
                        <div class="flex items-center">
                            <i class="mr-3 text-xl fas fa-phone-alt text-armyGreen"></i>
                            <a href="tel:+265123456789" class="hover:text-green-400">+265 123 456 789</a>
                        </div>
                        <div class="flex items-center">
                            <i class="mr-3 text-xl fas fa-envelope text-armyGreen"></i>
                            <a href="mailto:info@msacco.com" class="hover:text-green-400">info@msacco.com</a>
                        </div>
                        <div class="flex items-center">
                            <i class="mr-3 text-xl fas fa-clock text-armyGreen"></i>
                            <p>Monday - Friday: 9:00 AM - 5:00 PM</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>


    <!-- Footer Section -->
    <footer class="py-16 text-white bg-green-900">
        <div class="container px-6 mx-auto lg:px-6">
            <div class="flex flex-wrap justify-between">
                <!-- Logo and Description -->
                <div class="w-full mb-10 lg:w-1/4">
                    <div class="flex items-center gap-2 text-3xl font-bold">
                        <img src="images/logo.png" alt="Logo" class="w-auto h-12">
                        MSACCO
                    </div>
                    <p class="mt-4 text-gray-200">
                        MSACCO is a platform providing easy access to loans, deposits, and shares management with a seamless user experience.
                    </p>
                </div>

                <!-- Quick Links -->
                <div class="w-full mb-10 lg:w-1/4">
                    <h3 class="mb-4 text-xl font-bold">Quick Links</h3>
                    <ul class="space-y-3">
                        <li><a href="#about" class="hover:text-green-400">About Us</a></li>
                        <li><a href="#portfolio" class="hover:text-green-400">Projects</a></li>
                        <li><a href="#services" class="hover:text-green-400">Services</a></li>
                        <li><a href="#contact" class="hover:text-green-400">Contact Us</a></li>
                    </ul>
                </div>

                <!-- Download & Docs -->
                <div class="w-full mb-10 lg:w-1/4">
                    <h3 class="mb-4 text-xl font-bold">Resources</h3>
                    <ul class="space-y-3">
                        <li><a href="#" class="hover:text-green-400">Download Android App</a></li>
                        <li><a href="#" class="hover:text-green-400">Visit Documentation</a></li>
                        <li><a href="#" class="hover:text-green-400">Visit Admin Panel</a></li>
                    </ul>
                </div>

                <!-- Contact Information -->
                <div class="w-full mb-10 lg:w-1/4">
                    <h3 class="mb-4 text-xl font-bold">Contact Us</h3>
                    <p class="text-gray-200">123 Main Street, Lilongwe, Malawi</p>
                    <p class="mt-2 text-gray-200">Phone: <a href="tel:+265123456789" class="hover:text-green-400">+265 123 456 789</a></p>
                    <p class="mt-2 text-gray-200">Email: <a href="mailto:info@msacco.com" class="hover:text-green-400">info@msacco.com</a></p>
                </div>
            </div>

            <!-- Footer Bottom -->
            <div class="pt-6 mt-16 border-t border-gray-500">
                <div class="flex flex-wrap items-center justify-between">
                    <!-- Copyright -->
                    <p class="text-sm text-gray-300">&copy; 2024 MSACCO. All rights reserved.</p>

                    <!-- Social Media Links -->
                    <div class="flex space-x-6">
                        <a href="#" class="hover:text-green-400"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="hover:text-green-400"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="hover:text-green-400"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="hover:text-green-400"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>



    <!-- Script for Mobile Menu Toggle -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const menuToggle = document.getElementById("menu-toggle");
            const mobileMenu = document.getElementById("mobile-menu");

            menuToggle.addEventListener("click", function () {
                mobileMenu.classList.toggle("hidden");
                mobileMenu.classList.toggle("block");
            });
        });
    </script>

</body>

</html>
