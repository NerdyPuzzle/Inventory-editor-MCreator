package ${package}.client;

import net.minecraft.client.gui.components.Button;

<#include "../procedures.java.ftl">

<#assign elements = invedits>

<#assign width = 176>
<#assign height = 166>

<#assign labels = []>
<#assign images = []>
<#assign sprites = []>
<#assign buttons = []>
<#assign imagebuttons = []>
<#assign tooltips = []>
<#assign entitymodels = []>

<#list elements?filter(e -> e.getComponentsOfType("Label")?size != 0) as edit>
	<#assign labels += edit.getComponentsOfType("Label")>
</#list>

<#list elements?filter(e -> e.getComponentsOfType("Image")?size != 0) as edit>
	<#assign images += edit.getComponentsOfType("Image")>
</#list>

<#list elements?filter(e -> e.getComponentsOfType("Sprite")?size != 0) as edit>
	<#assign sprites += edit.getComponentsOfType("Sprite")>
</#list>

<#list elements?filter(e -> e.getComponentsOfType("Button")?size != 0) as edit>
	<#assign buttons += edit.getComponentsOfType("Button")>
</#list>

<#list elements?filter(e -> e.getComponentsOfType("ImageButton")?size != 0) as edit>
	<#assign imagebuttons += edit.getComponentsOfType("ImageButton")>
</#list>

<#list elements?filter(e -> e.getComponentsOfType("Tooltip")?size != 0) as edit>
	<#assign tooltips += edit.getComponentsOfType("Tooltip")>
</#list>

<#list elements?filter(e -> e.getComponentsOfType("EntityModel")?size != 0) as edit>
	<#assign entitymodels += edit.getComponentsOfType("EntityModel")>
</#list>

@EventBusSubscriber(Dist.CLIENT)
public class InventoryRenderer {
	private static Minecraft mc = Minecraft.getInstance();
	private static InventoryScreen screen = null;

	<#list images as component>
	    private static final ResourceLocation IMAGE_${component?index} = ResourceLocation.parse("${modid}:textures/screens/${component.image}");
	</#list>

	<#list sprites as component>
	    private static final ResourceLocation SPRITE_${component?index} = ResourceLocation.parse("${modid}:textures/screens/${component.sprite}");
	</#list>

	<#if buttons?size != 0 || imagebuttons?size != 0>
	    private static final List<AbstractWidget> buttons = new ArrayList<>();
	</#if>

	@SubscribeEvent
	public static void openScreen(ScreenEvent.Opening event) {
	    if (event.getNewScreen() instanceof InventoryScreen inventory) {
	        if (mc == null) mc = Minecraft.getInstance();
	        screen = inventory;
	        <#if buttons?size != 0 || imagebuttons?size != 0>initButtons();</#if>
	    }
	}

    <#if buttons?size != 0 || imagebuttons?size != 0>
	    @SubscribeEvent
	    public static void closeScreen(ScreenEvent.Closing event) {
            if (event.getScreen() instanceof InventoryScreen)
                buttons.clear();
	    }
	</#if>

	@SubscribeEvent
	public static void renderBackground(ContainerScreenEvent.Render.Background event) {
		if (!(event.getContainerScreen() instanceof InventoryScreen)) return;
		if (screen == null)
		    screen = (InventoryScreen) event.getContainerScreen();
		<#if buttons?size != 0 || imagebuttons?size != 0>
		    boolean flag = screen.getRecipeBookComponent().isVisible();
            <#assign btid = 0>
            if (!buttons.isEmpty()) {
            <#list buttons as component>
                buttons.get(${btid}).visible = !flag<#if hasProcedure(component.displayCondition)>&& <@valueProvider component.displayCondition/></#if>;
                <#assign btid += 1>
            </#list>
            }
		</#if>
		<#if sprites?size != 0 || images?size != 0>renderImages(event.getGuiGraphics(), event.getMouseX(), event.getMouseY());</#if>
	}

	@SubscribeEvent
	public static void renderForeground(ContainerScreenEvent.Render.Foreground event) {
		if (!(event.getContainerScreen() instanceof InventoryScreen)) return;
		if (screen == null)
		    screen = (InventoryScreen) event.getContainerScreen();

		<#if labels?size != 0>renderLabels(event.getGuiGraphics(), event.getMouseX(), event.getMouseY());</#if>
		<#if entitymodels?size != 0>renderEntityModels(event.getGuiGraphics(), event.getMouseX(), event.getMouseY());</#if>
		<#if tooltips?size != 0>renderTooltips(event.getGuiGraphics(), event.getMouseX(), event.getMouseY());</#if>
	}

	<#if buttons?size != 0 || imagebuttons?size != 0>
	private static void initButtons() {
	    <#assign btid = 0>
	    <#list buttons as component>
    	    <#if component.isUndecorated>
    			buttons.add(new PlainTextButton(
    				screen.getGuiLeft() + ${component.gx(width) + 125}, screen.getGuiTop() + ${component.gy(height) + 37},
    				${component.width}, ${component.height},
    				Component.translatable("invedit.${modid}.${component.getName()}"),
    				<@buttonOnClick component/>, mc.font));
    		<#else>
    			buttons.add(Button.builder(Component.translatable("invedit.${modid}.${component.getName()}"), <@buttonOnClick component/>)
    				.bounds(screen.getGuiLeft() + ${component.gx(width) + 125}, screen.getGuiTop() + ${component.gy(height) + 37},
    				${component.width}, ${component.height}).build());
    		</#if>
    		((WidgetInvoker)screen).callAddRenderableWidget(buttons.get(${btid}));
    		<#assign btid += 1>
	    </#list>
		<#list imagebuttons as component>
			buttons.add(new ImageButton(
				screen.getGuiLeft() + ${component.gx(width) + 125}, screen.getGuiTop() + ${component.gy(height) + 37},
				${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
				<#if component.hoveredImage?has_content>
				new WidgetSprites(ResourceLocation.parse("${modid}:textures/screens/${component.image}"), ResourceLocation.parse("${modid}:textures/screens/${component.hoveredImage}")),
				<#else>
				new WidgetSprites(ResourceLocation.parse("${modid}:textures/screens/${component.image}"), ResourceLocation.parse("${modid}:textures/screens/${component.image}")),
				</#if>
				<@buttonOnClick component/>
			) {
				@Override public void renderWidget(GuiGraphics guiGraphics, int mouseX, int mouseY, float partialTicks) {
					if (!screen.getRecipeBookComponent().isVisible()<#if hasProcedure(component.displayCondition)> && <@valueProvider component.displayCondition/></#if>)
					    guiGraphics.blit(sprites.get(isActive(), isHoveredOrFocused()), getX(), getY(), 0, 0, width, height, width, height);
				}
			});
			((WidgetInvoker)screen).callAddRenderableWidget(buttons.get(${btid}));
			<#assign btid += 1>
		</#list>
	}
	</#if>

	<#if sprites?size != 0 || images?size != 0>
	private static void renderImages(GuiGraphics guiGraphics, int mouseX, int mouseY) {
		<#list images as component>
			<#if hasProcedure(component.displayCondition)>if (<@valueProvider component.displayCondition/>) {</#if>
				guiGraphics.blit(IMAGE_${component?index},
					screen.getGuiLeft() + ${component.gx(width)}, screen.getGuiTop() + ${component.gy(height)}, 0, 0,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>}</#if>
		</#list>
    	<#list sprites as component>
    		<#if hasProcedure(component.displayCondition)>if (<@valueProvider component.displayCondition/>) {</#if>
    			guiGraphics.blit(SPRITE_${component?index},
    				screen.getGuiLeft() + ${component.gx(width)}, screen.getGuiTop() + ${component.gy(height)},
    				<#if (component.getTextureWidth(w.getWorkspace()) > component.getTextureHeight(w.getWorkspace()))>
    					<@getSpriteByIndex component "width"/>, 0
    				<#else>
    					0, <@getSpriteByIndex component "height"/>
    				</#if>,
    				${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
    				${component.getTextureWidth(w.getWorkspace())}, ${component.getTextureHeight(w.getWorkspace())});
    		<#if hasProcedure(component.displayCondition)>}</#if>
    	</#list>
	}
	</#if>

	<#if labels?size != 0>
	private static void renderLabels(GuiGraphics guiGraphics, int mouseX, int mouseY) {
		<#list labels as component>
			<#if hasProcedure(component.displayCondition)>
				if (<@valueProvider component.displayCondition/>)
			</#if>
			guiGraphics.drawString(mc.font,
				<#if hasProcedure(component.text)><@valueProvider component.text/><#else>Component.translatable("invedit.${modid}.${component.getName()}")</#if>,
				${component.gx(width)}, ${component.gy(height)}, ${component.color.getRGB()}, ${component.hasShadow});
		</#list>
	}
	</#if>

	<#if entitymodels?size != 0>
	private static void renderEntityModels(GuiGraphics guiGraphics, int mouseX, int mouseY) {
	    <#list entitymodels as component>
			<#assign followMouse = component.followMouseMovement>
			<#assign x = component.gx(width)>
			<#assign y = component.gy(height)>
			if (<@valueProvider component.entityModel/> instanceof LivingEntity livingEntity) {
				<#if hasProcedure(component.displayCondition)>
					if (<@valueProvider component.displayCondition/>)
				</#if>
				renderEntityInInventoryFollowsAngle(guiGraphics, screen.getGuiLeft() + ${x + 10 - 125}, screen.getGuiTop() + ${y + 20 - 37}, ${component.scale},
					${component.rotationX / 20.0}f <#if followMouse> + (float) Math.atan((screen.getGuiLeft() + ${x + 10} - mouseX) / 40.0)</#if>,
					<#if followMouse>(float) Math.atan((screen.getGuiTop() + ${y + 21 - 50} - mouseY) / 40.0)<#else>0</#if>, livingEntity);
			}
	    </#list>
	}
	</#if>

	<#if tooltips?size != 0>
	private static void renderTooltips(GuiGraphics guiGraphics, int mouseX, int mouseY) {
		<#list tooltips as component>
			<#assign x = component.gx(width)>
			<#assign y = component.gy(height)>
			<#if hasProcedure(component.displayCondition)>
				if (<@valueProvider component.displayCondition/>)
			</#if>
				if (mouseX > screen.getGuiLeft() + ${x} && mouseX < screen.getGuiLeft() + ${x + component.width} && mouseY > screen.getGuiTop() + ${y} && mouseY < screen.getGuiTop() + ${y + component.height}) {
					<#if hasProcedure(component.text)>
					String hoverText = <@valueProvider component.text/>;
					if (hoverText != null) {
						guiGraphics.renderComponentTooltip(mc.font, Arrays.stream(hoverText.split("\n")).map(Component::literal).collect(Collectors.toList()), mouseX - 125, mouseY - 37);
					}
					<#else>
						guiGraphics.renderTooltip(mc.font, Component.translatable("invedit.${modid}.${component.getName()}"), mouseX - 125, mouseY - 37);
					</#if>
				}
		</#list>
	}
	</#if>

	<#if entitymodels?size != 0>
	private static void renderEntityInInventoryFollowsAngle(GuiGraphics guiGraphics, int x, int y, int scale, float angleXComponent, float angleYComponent, LivingEntity entity) {
		Quaternionf pose = new Quaternionf().rotateZ((float)Math.PI);
		Quaternionf cameraOrientation = new Quaternionf().rotateX(angleYComponent * 20 * ((float) Math.PI / 180F));
		pose.mul(cameraOrientation);
		float f2 = entity.yBodyRot;
		float f3 = entity.getYRot();
		float f4 = entity.getXRot();
		float f5 = entity.yHeadRotO;
		float f6 = entity.yHeadRot;
		entity.yBodyRot = 180.0F + angleXComponent * 20.0F;
		entity.setYRot(180.0F + angleXComponent * 40.0F);
		entity.setXRot(-angleYComponent * 20.0F);
		entity.yHeadRot = entity.getYRot();
		entity.yHeadRotO = entity.getYRot();
		InventoryScreen.renderEntityInInventory(guiGraphics, x, y, scale, new Vector3f(0, 0, 0), pose, cameraOrientation, entity);
		entity.yBodyRot = f2;
		entity.setYRot(f3);
		entity.setXRot(f4);
		entity.yHeadRotO = f5;
		entity.yHeadRot = f6;
	}
	</#if>
}

<#macro valueProvider procedure="">
	<@procedureCode procedure, {
		"x": "mc.player.getX()",
		"y": "mc.player.getY()",
		"z": "mc.player.getZ()",
		"world": "mc.level",
		"entity": "mc.player"
	}, false/>
</#macro>

<#macro getSpriteByIndex component dim>
	<#if hasProcedure(component.spriteIndex)>
		Mth.clamp((int) <@valueProvider component.spriteIndex/> *
			<#if dim == "width">
				${component.getWidth(w.getWorkspace())}
			<#else>
				${component.getHeight(w.getWorkspace())}
			</#if>,
			0,
			<#if dim == "width">
				${component.getTextureWidth(w.getWorkspace()) - component.getWidth(w.getWorkspace())}
			<#else>
				${component.getTextureHeight(w.getWorkspace()) - component.getHeight(w.getWorkspace())}
			</#if>
		)
	<#else>
		<#if dim == "width">
			${component.getWidth(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		<#else>
			${component.getHeight(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		</#if>
	</#if>
</#macro>

<#macro buttonOnClick component>
e -> {
    <#if hasProcedure(component.onClick)>
	if (!screen.getRecipeBookComponent().isVisible()<#if hasProcedure(component.displayCondition)> && <@valueProvider component.displayCondition/></#if>) {
		PacketDistributor.sendToServer(new ${JavaModName}InventoryButtonMessage(${btid}, (int) mc.player.getX(), (int) mc.player.getY(), (int) mc.player.getZ()));
		${JavaModName}InventoryButtonMessage.handleButtonAction(mc.player, ${btid}, (int) mc.player.getX(), (int) mc.player.getY(), (int) mc.player.getZ());
	}
	</#if>
}
</#macro>