#include <stdio.h>
#include "raylib.h"
#include "raygui.h"

#define ANCHO 1280
#define ALTO 720

int main(void)
{
    // Inicializamos la ventana
    InitWindow(ANCHO, ALTO, "Datacenter Tycoon");
    SetWindowMinSize(800, 450);

    // Establecemos los FPS
    SetTargetFPS(60);

    // Estado del boton
    bool botonPresionado = false;

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(BLACK);
        DrawText("Bienvenido a Datacenter Tycoon", 190, 200, 20, WHITE);

        if (GuiButton((Rectangle){300, 300, 200, 50}, "¡Presióname!"))
        {
            botonPresionado = !botonPresionado;
        }

        if (botonPresionado)
        {
            DrawText("¡Botón Activado!", 360, 280, 20, RED);
        }

        EndDrawing();
    }

    CloseWindow();
    printf("Programa Finalizado\n");
    return 0;
}