package learn.loginit;

import java.io.File;

import org.apache.log4j.PropertyConfigurator;

public class LogUtil {
	
	public static void logSettingInit(){
		final String log4jdir = System.getProperty("user.dir")
	      +File.separator+"src"+File.separator+"main"+File.separator
	      +"webapp"+File.separator+"WEB-INF"
	      +File.separator+"conf"+File.separator+"log4j.properties";
		PropertyConfigurator.configure(log4jdir);
	}
}
