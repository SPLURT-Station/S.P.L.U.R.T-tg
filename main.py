# Import necessary modules
import pygame
from pygame.locals import *

# Define the base-game plushies
BASE_GAME_PLUSHIES = {
    'syndicate': 'assets/plushies/syndicate.png',
    'abductor': 'assets/plushies/abductor.png',
    'fox': 'assets/plushies/fox.png'
}

# Initialize Pygame
pygame.init()

# Set up the display
screen = pygame.display.set_mode((800, 600))
pygame.display.set_caption('Plushie Portal')

# Load the default portal image
default_portal_image = pygame.image.load('assets/portal/default.png')
current_portal_image = default_portal_image

# Function to change the portal appearance
def change_portal_appearance(plushie_type):
    global current_portal_image
    if plushie_type in BASE_GAME_PLUSHIES:
        current_portal_image = pygame.image.load(BASE_GAME_PLUSHIES[plushie_type])
    else:
        print(f"Plushie type '{plushie_type}' not found.")

# Main game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == QUIT:
            running = False
        elif event.type == KEYDOWN:
            if event.key == K_1:
                change_portal_appearance('syndicate')
            elif event.key == K_2:
                change_portal_appearance('abductor')
            elif event.key == K_3:
                change_portal_appearance('fox')

    # Clear the screen
    screen.fill((0, 0, 0))

    # Draw the current portal image
    screen.blit(current_portal_image, (350, 250))

    # Update the display
    pygame.display.flip()

# Clean up
pygame.quit()