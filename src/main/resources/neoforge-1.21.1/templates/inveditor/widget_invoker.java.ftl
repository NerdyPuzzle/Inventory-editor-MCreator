package ${package}.mixin;

@Mixin(Screen.class)
public interface WidgetInvoker {
    @Invoker <T extends GuiEventListener & Renderable & NarratableEntry> T callAddRenderableWidget(T p_169406_);
}