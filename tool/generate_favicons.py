"""Generate small browser icons from assets/icons/portfolio.png.

The thin handwritten wordmark disappears when simply downscaled, so strokes are
thickened for small sizes and 16px uses only the "P" initial.

Run from the project root: python tool/generate_favicons.py  (requires Pillow)
"""

from PIL import Image, ImageFilter, ImageOps

SOURCE = 'assets/icons/portfolio.png'
INK = (28, 28, 30)

source = Image.open(SOURCE).convert('RGB')
background = source.getpixel((5, 5))
ink_mask = ImageOps.invert(source.convert('L'))
left, top, right, bottom = ink_mask.point(lambda v: 255 if v > 60 else 0).getbbox()


def render(mask, size, boost):
    mask = mask.resize((size, size), Image.LANCZOS)
    mask = mask.point(lambda v: min(255, int(v * boost)))
    icon = Image.new('RGB', (size, size), background)
    icon.paste(Image.new('RGB', (size, size), INK), mask=mask)
    return icon


def wordmark(size, grow, padding=0.06):
    ink = ink_mask.filter(ImageFilter.MaxFilter(grow)) if grow > 1 else ink_mask
    width = right - left
    side = width + 2 * int(width * padding)
    cx, cy = (left + right) // 2, (top + bottom) // 2
    box = (cx - side // 2, cy - side // 2, cx + side // 2, cy + side // 2)
    return render(ink.crop(box), size, 2.2 if grow > 1 else 1.4)


def initial(size, grow):
    ink = ink_mask.filter(ImageFilter.MaxFilter(grow))
    canvas = Image.new('L', (380, 380), 0)
    canvas.paste(ink.crop((302, 438, 452, 766)), (115, 26))
    return render(canvas, size, 2.4)


favicon_16 = initial(16, 25)
favicon_32 = wordmark(32, 13)
favicon_48 = wordmark(48, 11)

favicon_48.save('web/favicon.ico', sizes=[(16, 16), (32, 32), (48, 48)],
                append_images=[favicon_16, favicon_32])
favicon_16.save('web/icons/favicon-16.png')
favicon_32.save('web/icons/favicon-32.png')
favicon_48.save('web/favicon.png')
wordmark(180, 5, padding=0.14).save('web/apple-touch-icon.png')
print('Generated favicon.ico, favicon PNGs and apple-touch-icon.png in web/')
