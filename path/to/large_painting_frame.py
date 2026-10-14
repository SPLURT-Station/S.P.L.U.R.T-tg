class LargePaintingFrame:
    def __init__(self):
        self.can_be_crafted = True
        self.can_be_bought = True
        self.price = 100  # Example price

    def craft(self, materials):
        if self.can_be_crafted:
            if self.check_materials(materials):
                print('Crafting large painting frame...')
                # Logic to craft the frame
                return True
            else:
                print('Not enough materials to craft.')
                return False
        else:
            print('This frame cannot be crafted.')
            return False

    def buy(self, player):
        if self.can_be_bought:
            if player.balance >= self.price:
                player.balance -= self.price
                print('Large painting frame purchased!')
                # Logic to add frame to player's inventory
                return True
            else:
                print('Not enough balance to buy the frame.')
                return False
        else:
            print('This frame cannot be bought.')
            return False

    def check_materials(self, materials):
        # Logic to check if the required materials are present
        return True  # Placeholder for actual material check