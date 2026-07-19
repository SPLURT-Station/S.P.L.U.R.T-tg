import pygame
import os

# Initialize Pygame
pygame.init()

# Set up the display
screen_width = 800
screen_height = 600
screen = pygame.display.set_mode((screen_width, screen_height))
pygame.display.set_caption('Mantled Beast Markings')

# Directory where the images are stored
image_dir = 'assets/mantled_beast_markings'

# Load the images
images = []
for filename in os.listdir(image_dir):
    if filename.endswith('.png'):
        image_path = os.path.join(image_dir, filename)
        image = pygame.image.load(image_path).convert_alpha()
        images.append(image)

# Main game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Clear the screen
    screen.fill((0, 0, 0))

    # Draw the images
    for i, image in enumerate(images):
        x = (i % 5) * 100 + 50  # Adjust the position as needed
        y = (i // 5) * 100 + 50  # Adjust the position as needed
        screen.blit(image, (x, y))

    # Update the display
    pygame.display.flip()

# Clean up
pygame.quit()