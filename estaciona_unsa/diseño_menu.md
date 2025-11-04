<!DOCTYPE html>
<html class="light" lang="es"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>UNSA Parking - Disponibilidad</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
<script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#8A0000",
                        "accent": "#007AFF",
                        "background-light": "#f6f7f8",
                        "background-dark": "#101922",
                        "card-light": "#ffffff",
                        "card-dark": "#1C2A38",
                        "text-light": "#101922",
                        "text-dark": "#f6f7f8",
                        "text-secondary-light": "#6b7280",
                        "text-secondary-dark": "#9ca3af",
                        "available": "#28a745",
                        "limited": "#ffc107",
                        "full": "#dc3545",
                        "border-light": "#e5e7eb",
                        "border-dark": "#374151"
                    },
                    fontFamily: {
                        "display": ["Public Sans", "sans-serif"]
                    },
                    borderRadius: {
                        "DEFAULT": "0.5rem",
                        "lg": "0.75rem",
                        "xl": "1rem",
                        "full": "9999px"
                    },
                },
            },
        }
    </script>
<style>
        body {
            min-height: 100dvh;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background-light dark:bg-background-dark font-display text-text-light dark:text-text-dark">
<div class="relative flex h-full min-h-screen w-full flex-col group/design-root">
<div class="flex flex-col h-full flex-1">
<header class="sticky top-0 z-10 bg-background-light/80 dark:bg-background-dark/80 backdrop-blur-sm shadow-sm">
<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
<div class="flex items-center justify-between h-16">
<div class="flex items-center">
<span class="material-symbols-outlined text-primary text-3xl">directions_car</span>
<h1 class="text-xl font-bold ml-2 text-text-light dark:text-text-dark">UNSA Parking</h1>
</div>
<button class="flex items-center justify-center p-2 rounded-full hover:bg-gray-200 dark:hover:bg-gray-700">
<span class="material-symbols-outlined">
                                account_circle
                            </span>
</button>
</div>
</div>
</header>
<main class="flex-1 pb-10">
<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
<div class="pt-6 pb-4">
<h2 class="text-2xl font-bold leading-tight text-text-light dark:text-text-dark">Resumen General</h2>
<p class="mt-1 text-base text-text-secondary-light dark:text-text-secondary-dark">Estado rápido de todas las áreas</p>
</div>
<div class="flex flex-nowrap overflow-x-auto gap-4 pb-4 -mx-4 px-4 sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8">
<div class="flex-none w-5/6 sm:w-1/2 md:w-1/3 lg:w-1/4 xl:w-1/5 bg-card-light dark:bg-card-dark rounded-xl shadow-md min-w-[200px] border-l-4 border-available">
<button class="block w-full text-left p-4 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 rounded-xl">
<h3 class="text-lg font-semibold text-text-light dark:text-text-dark truncate">Ingenierías</h3>
<p class="text-sm text-text-secondary-light dark:text-text-secondary-dark mt-1">
<span class="text-available font-medium">Mayormente Disponible</span>
</p>
<div class="mt-3 flex items-center text-sm text-text-light dark:text-text-dark">
<span class="material-symbols-outlined text-base mr-1 text-available">check_circle</span>
                23/245 Libres
            </div>
</button>
</div>
<div class="flex-none w-5/6 sm:w-1/2 md:w-1/3 lg:w-1/4 xl:w-1/5 bg-card-light dark:bg-card-dark rounded-xl shadow-md min-w-[200px] border-l-4 border-limited">
<button class="block w-full text-left p-4 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 rounded-xl">
<h3 class="text-lg font-semibold text-text-light dark:text-text-dark truncate">Sociales</h3>
<p class="text-sm text-text-secondary-light dark:text-text-secondary-dark mt-1">
<span class="text-limited font-medium">Plazas Limitadas</span>
</p>
<div class="mt-3 flex items-center text-sm text-text-light dark:text-text-dark">
<span class="material-symbols-outlined text-base mr-1 text-limited">error</span>
                8/150 Libres
            </div>
</button>
</div>
<div class="flex-none w-5/6 sm:w-1/2 md:w-1/3 lg:w-1/4 xl:w-1/5 bg-card-light dark:bg-card-dark rounded-xl shadow-md min-w-[200px] border-l-4 border-full">
<button class="block w-full text-left p-4 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 rounded-xl">
<h3 class="text-lg font-semibold text-text-light dark:text-text-dark truncate">Biomédicas</h3>
<p class="text-sm text-text-secondary-light dark:text-text-secondary-dark mt-1">
<span class="text-full font-medium">Completo</span>
</p>
<div class="mt-3 flex items-center text-sm text-text-light dark:text-text-dark">
<span class="material-symbols-outlined text-base mr-1 text-full">cancel</span>
                0/100 Libres
            </div>
</button>
</div>
</div>
<div class="pt-6">
<h2 class="text-2xl font-bold leading-tight text-text-light dark:text-text-dark">Área de Ingenierías</h2>
<p class="mt-1 text-base text-text-secondary-light dark:text-text-secondary-dark">Disponibilidad en tiempo real</p>
</div>
<div class="space-y-4 mt-4">
<div class="bg-card-light dark:bg-card-dark rounded-xl shadow-md overflow-hidden">
<div class="p-5">
<div class="flex items-center justify-between">
<h3 class="text-lg font-semibold text-text-light dark:text-text-dark">Estacionamiento Paucarpata</h3>
<span class="flex items-center text-sm font-medium text-available">
<span class="material-symbols-outlined text-base mr-1">check_circle</span>
                                        Disponible
                                    </span>
</div>
<p class="text-sm text-text-secondary-light dark:text-text-secondary-dark">Total: 75 plazas</p>
<div class="mt-4">
<div class="flex justify-between items-center mb-1">
<p class="text-sm font-medium text-text-light dark:text-text-dark">Disponibles</p>
<p class="text-sm font-bold text-text-light dark:text-text-dark">
<span class="text-available">23</span> / 75
                                        </p>
</div>
<div class="w-full bg-border-light dark:bg-border-dark rounded-full h-2.5">
<div class="bg-available h-2.5 rounded-full" style="width: 30.67%"></div>
</div>
</div>
</div>
</div>
<div class="bg-card-light dark:bg-card-dark rounded-xl shadow-md overflow-hidden">
<div class="p-5">
<div class="flex items-center justify-between">
<h3 class="text-lg font-semibold text-text-light dark:text-text-dark">Estacionamiento Av. Independencia</h3>
<span class="flex items-center text-sm font-medium text-limited">
<span class="material-symbols-outlined text-base mr-1">error</span>
                                        Plazas limitadas
                                    </span>
</div>
<p class="text-sm text-text-secondary-light dark:text-text-secondary-dark">Total: 120 plazas</p>
<div class="mt-4">
<div class="flex justify-between items-center mb-1">
<p class="text-sm font-medium text-text-light dark:text-text-dark">Disponibles</p>
<p class="text-sm font-bold text-text-light dark:text-text-dark">
<span class="text-limited">8</span> / 120
                                        </p>
</div>
<div class="w-full bg-border-light dark:bg-border-dark rounded-full h-2.5">
<div class="bg-limited h-2.5 rounded-full" style="width: 6.67%"></div>
</div>
</div>
</div>
</div>
<div class="bg-card-light dark:bg-card-dark rounded-xl shadow-md overflow-hidden">
<div class="p-5">
<div class="flex items-center justify-between">
<h3 class="text-lg font-semibold text-text-light dark:text-text-dark">Estacionamiento Av. Venezuela</h3>
<span class="flex items-center text-sm font-medium text-full">
<span class="material-symbols-outlined text-base mr-1">cancel</span>
                                        Completo
                                    </span>
</div>
<p class="text-sm text-text-secondary-light dark:text-text-secondary-dark">Total: 50 plazas</p>
<div class="mt-4">
<div class="flex justify-between items-center mb-1">
<p class="text-sm font-medium text-text-light dark:text-text-dark">Disponibles</p>
<p class="text-sm font-bold text-text-light dark:text-text-dark">
<span class="text-full">0</span> / 50
                                        </p>
</div>
<div class="w-full bg-border-light dark:bg-border-dark rounded-full h-2.5">
<div class="bg-full h-2.5 rounded-full" style="width: 0%"></div>
</div>
</div>
</div>
</div>
</div>
</div>
</main>
<nav class="sticky bottom-0 bg-card-light dark:bg-card-dark border-t border-border-light dark:border-border-dark shadow-t-lg">
<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
<div class="flex justify-around h-16">
<a class="flex flex-col items-center justify-center w-full text-primary" href="#">
<span class="material-symbols-outlined">space_dashboard</span>
<span class="text-xs font-medium">Disponibilidad</span>
</a>
<a class="flex flex-col items-center justify-center w-full text-text-secondary-light dark:text-text-secondary-dark hover:text-primary dark:hover:text-primary" href="#">
<span class="material-symbols-outlined">map</span>
<span class="text-xs font-medium">Mapa</span>
</a>
<a class="flex flex-col items-center justify-center w-full text-text-secondary-light dark:text-text-secondary-dark hover:text-primary dark:hover:text-primary" href="#">
<span class="material-symbols-outlined">history</span>
<span class="text-xs font-medium">Historial</span>
</a>
<a class="flex flex-col items-center justify-center w-full text-text-secondary-light dark:text-text-secondary-dark hover:text-primary dark:hover:text-primary" href="#">
<span class="material-symbols-outlined">credit_card</span>
<span class="text-xs font-medium">Pagos</span>
</a>
</div>
</div>
</nav>
</div>
</div>

</body></html>