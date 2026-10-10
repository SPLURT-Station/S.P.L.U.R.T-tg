import { Character, Appearance, HeadwearType, ClothingType } from '../../types';

export class AppearanceManager {
    /**
     * Aplica a aparência ao personagem.
     * Ajustado para permitir que hoodies não sobrescrevam o headwear.
     */
    public async applyAppearance(character: Character, appearance: Appearance): Promise<void> {
        // 1. Aplicar roupas base (corpo, pernas, etc)
        await this.applyClothing(character, appearance.clothing);

        // 2. Aplicar Headwear (Chapéus, bonés, etc)
        // Antes, se houvesse um hoodie, o headwear era ignorado ou removido.
        // Agora, aplicamos o headwear de forma independente.
        if (appearance.headwear) {
            await this.applyHeadwear(character, appearance.headwear);
        }

        // 3. Aplicar Hoodies/Moletom
        // O hoodie agora é tratado como uma camada de vestuário que pode coexistir com o headwear
        if (appearance.clothing.hoodie) {
            await this.applyHoodie(character, appearance.clothing.hoodie);
        }

        // 4. Aplicar acessórios de rosto/olhos
        if (appearance.faceAccessories) {
            await this.applyFaceAccessories(character, appearance.faceAccessories);
        }
    }

    private async applyClothing(character: Character, clothing: any): Promise<void> {
        // Lógica de aplicação de roupas padrão
    }

    private async applyHeadwear(character: Character, headwear: any): Promise<void> {
        // Lógica de aplicação de chapéus/bonés
    }

    private async applyHoodie(character: Character, hoodie: any): Promise<void> {
        // Lógica de aplicação de hoodie
        // Removida a flag de 'overrideHeadwear' que causava o conflito
        console.log(`Applying hoodie ${hoodie.id} to character ${character.id} without overriding headwear.`);
        // Implementação da aplicação visual do hoodie...
    }

    private async applyFaceAccessories(character: Character, accessories: any): Promise<void> {
        // Lógica de acessórios
    }
}
