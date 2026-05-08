package ${package}.mixin;

import org.spongepowered.asm.mixin.gen.Accessor;

@Mixin(AbstractRecipeBookScreen.class)
public interface RecipeBookAccessor {
    @Accessor RecipeBookComponent<?> getRecipeBookComponent();
}