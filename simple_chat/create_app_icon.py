#!/usr/bin/env python3
"""
Script to create app icons from SVG
This script converts the SVG icon to different PNG sizes needed for Android
"""

import os
from PIL import Image, ImageDraw

def create_gradient_circle(size, colors):
    """Create a gradient circle background"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Create gradient effect by drawing multiple circles
    center = size // 2
    max_radius = center - 10
    
    for i in range(max_radius):
        # Interpolate between colors
        ratio = i / max_radius
        if ratio < 0.5:
            # First half: blend first two colors
            blend_ratio = ratio * 2
            r = int(colors[0][0] * (1 - blend_ratio) + colors[1][0] * blend_ratio)
            g = int(colors[0][1] * (1 - blend_ratio) + colors[1][1] * blend_ratio)
            b = int(colors[0][2] * (1 - blend_ratio) + colors[1][2] * blend_ratio)
        else:
            # Second half: blend second and third colors
            blend_ratio = (ratio - 0.5) * 2
            r = int(colors[1][0] * (1 - blend_ratio) + colors[2][0] * blend_ratio)
            g = int(colors[1][1] * (1 - blend_ratio) + colors[2][1] * blend_ratio)
            b = int(colors[1][2] * (1 - blend_ratio) + colors[2][2] * blend_ratio)
        
        color = (r, g, b, 255)
        radius = max_radius - i
        draw.ellipse([center - radius, center - radius, center + radius, center + radius], 
                    fill=color)
    
    return img

def create_chat_icon(size):
    """Create the chat icon with the specified size"""
    # Colors for gradient (RGB)
    colors = [
        (78, 205, 196),   # #4ECDC4
        (68, 160, 141),   # #44A08D  
        (9, 54, 55)       # #093637
    ]
    
    # Create base image with gradient background
    img = create_gradient_circle(size, colors)
    draw = ImageDraw.Draw(img)
    
    # Calculate proportional sizes
    scale = size / 512
    
    # Draw main chat bubble
    bubble_width = int(200 * scale)
    bubble_height = int(120 * scale)
    bubble_x = int(80 * scale)
    bubble_y = int(150 * scale)
    
    # Main bubble (darker blue)
    draw.rounded_rectangle(
        [bubble_x, bubble_y, bubble_x + bubble_width, bubble_y + bubble_height],
        radius=int(25 * scale),
        fill=(68, 160, 141, 200)
    )
    
    # Secondary bubble (lighter green)
    bubble2_width = int(140 * scale)
    bubble2_height = int(80 * scale)
    bubble2_x = int(250 * scale)
    bubble2_y = int(220 * scale)
    
    draw.rounded_rectangle(
        [bubble2_x, bubble2_y, bubble2_x + bubble2_width, bubble2_y + bubble2_height],
        radius=int(20 * scale),
        fill=(168, 230, 207, 180)
    )
    
    # Draw chat dots in main bubble
    dot_radius = int(12 * scale)
    dot_y = bubble_y + bubble_height // 2
    
    for i, dot_x in enumerate([bubble_x + 40, bubble_x + 80, bubble_x + 120]):
        dot_x = int(dot_x * scale)
        draw.ellipse([dot_x - dot_radius, dot_y - dot_radius, 
                     dot_x + dot_radius, dot_y + dot_radius], 
                    fill=(255, 255, 255, 220))
    
    # Draw smaller dots in secondary bubble
    small_dot_radius = int(8 * scale)
    small_dot_y = bubble2_y + bubble2_height // 2
    
    for i, dot_x in enumerate([bubble2_x + 25, bubble2_x + 50, bubble2_x + 75]):
        dot_x = int(dot_x * scale)
        draw.ellipse([dot_x - small_dot_radius, small_dot_y - small_dot_radius,
                     dot_x + small_dot_radius, small_dot_y + small_dot_radius],
                    fill=(255, 255, 255, 200))
    
    return img

def create_all_icons():
    """Create all required icon sizes for Android"""
    # Android icon sizes
    sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192
    }
    
    # Create directories
    android_res_path = 'android/app/src/main/res'
    
    for folder, size in sizes.items():
        folder_path = os.path.join(android_res_path, folder)
        os.makedirs(folder_path, exist_ok=True)
        
        # Create icon
        icon = create_chat_icon(size)
        icon_path = os.path.join(folder_path, 'ic_launcher.png')
        icon.save(icon_path, 'PNG')
        print(f"Created {icon_path} ({size}x{size})")
    
    # Create a large icon for general use
    large_icon = create_chat_icon(512)
    large_icon.save('assets/icons/app_icon_512.png', 'PNG')
    print("Created assets/icons/app_icon_512.png (512x512)")

if __name__ == "__main__":
    create_all_icons()
    print("All app icons created successfully!")
