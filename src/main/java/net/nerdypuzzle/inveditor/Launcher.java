package net.nerdypuzzle.inveditor;

import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.nerdypuzzle.inveditor.parts.PluginElementTypes;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Launcher extends JavaPlugin {

	private static final Logger LOG = LogManager.getLogger("Inventory editor");

	public Launcher(Plugin plugin) {
		super(plugin);

        addListener(PreGeneratorsLoadingEvent.class, event -> {
            PluginElementTypes.load();
        });

		LOG.info("Inventory editor plugin was loaded");
	}

}