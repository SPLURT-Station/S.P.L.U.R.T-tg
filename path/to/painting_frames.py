class PaintingFrame:
    def __init__(self, size, can_be_crafted=True, can_be_bought=True):
        self.size = size
        self.can_be_crafted = can_be_crafted
        self.can_be_bought = can_be_bought

    def craft(self):
        if self.can_be_crafted:
            # Logic for crafting the painting frame
            return f'{self.size} painting frame crafted.'
        return 'Crafting not allowed for this frame.'

    def buy(self):
        if self.can_be_bought:
            # Logic for buying the painting frame
            return f'{self.size} painting frame bought.'
        return 'Buying not allowed for this frame.'

# Example usage:
large_frame = PaintingFrame(size='large')
print(large_frame.craft())
print(large_frame.buy())