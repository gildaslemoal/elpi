package org.ofbiz.testtools.webdriverTests.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHttpEntityEnclosingRequest;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Platform;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.logging.LogEntries;
import org.openqa.selenium.logging.LogEntry;
import org.openqa.selenium.logging.LogType;
import org.openqa.selenium.logging.LoggingPreferences;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.HttpCommandExecutor;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;


@SuppressWarnings("deprecation")
public class WebdriverTestCase {
    private static final String resource = "selenium.properties";
    protected static WebDriver driver;
    protected static Actions actions;
    JavascriptExecutor js;
    protected static WebDriverWait driverWait;
    protected String testType = Utils.getPropertyValue(resource, "testType", "local");
    protected String videoCapture = Utils.getPropertyValue(resource, "record.video", "no");
    protected String imageCapture = Utils.getPropertyValue(resource, "record.screenshots", "no");
    protected String targetBrowser = Utils.getPropertyValue(resource, "targetBrowser", "firefox");
    protected String targetPlatforme = Utils.getPropertyValue(resource, "targetPlatforme", "LINUX");
    
    protected String OUTPUT_DIR;
    protected Platform platforme = Platform.LINUX;
    protected String name;
    public String testName;
    public String sessionId;
    protected boolean recordingStarted = false;
    protected static String ofbizBaseUrl = Utils.getPropertyValue(resource, "ofbizBaseUrl", "https://localhost:8443/");
    protected String gridHubUrl = Utils.getPropertyValue(resource, "gridHubUrl", "http://localhost:4444/wd/hub/");
    @Before
    public void initDriver() throws Exception {
        if("local".equals(testType) || "all".equals(testType)) {
            if ("firefox".equals(targetBrowser)) {
                driver = new FirefoxDriver();
            }
            if ("chrome".equals(targetBrowser)) {
                driver = new ChromeDriver();
            }
        }

        OUTPUT_DIR = System.getProperty("BUILD_OUTPUT");

        name = readPropertyOrEnv("BUILD_TAG", getClass().getSimpleName());
        DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
        desiredCapabilities.setCapability("name", name);
        
        if (targetPlatforme.equalsIgnoreCase("WINDOWS")) {
            platforme = Platform.WINDOWS;
        }
        desiredCapabilities.setCapability(CapabilityType.PLATFORM, platforme);
        desiredCapabilities.setJavascriptEnabled(true);
        if ("no".equals(videoCapture)) {
            desiredCapabilities.setCapability("record-video", false);
        }
        if ("no".equals(imageCapture)) {
            desiredCapabilities.setCapability("record-screenshots", false);
        }//we need this if use sauce lab integration
        //targetBrowser = readPropertyOrEnv("SELENIUM_BROWSER", targetBrowser);
        desiredCapabilities.setBrowserName(targetBrowser);
        System.out.println(System.getProperty("webdriver.chrome.driver"));
        if("htmlUnit".equals(testType)) {
            driver = new HtmlUnitDriver(desiredCapabilities);
        }
        LoggingPreferences logs = new LoggingPreferences(); 
        logs.enable(LogType.PROFILER, Level.INFO);
        desiredCapabilities.setCapability(CapabilityType.LOGGING_PREFS, logs);
        URL gridurl = new URL(gridHubUrl);
        
        if ("grid".equals(testType) || "all".equals(testType)) {
            driver = new RemoteWebDriver(gridurl, desiredCapabilities);
        }
        if (driver instanceof JavascriptExecutor) {
            js = (JavascriptExecutor) driver;
        }
        RemoteWebDriver rd = (RemoteWebDriver) driver;
        sessionId = rd.getSessionId().toString();
        rd.setLogLevel(Level.INFO);
        driver.manage().window().maximize();
        recordingStarted = startRecording();
        actions = new Actions(driver);
    }
    @After
    public void finalizing() throws Exception{
        if (recordingStarted) {
            if (testName == null) {
                testName = getClass().getSimpleName();
            }
            String videoFileName = testName;
            if(name != null) {
                videoFileName = name + "-" + videoFileName;
            }
            videoFileName = videoFileName.replaceAll(" ", "-");
            videoFileName = videoFileName.replaceAll("\\.", "-");
            getTestLogs(videoFileName);
            stopRecording(videoFileName);
        }
        driver.quit();
    }

    public void zoomAndSendKeys(String elementId, String text)  throws Exception{
        zoomAndSendKeys(elementId, 200, text);
    }
    public void zoomAndSendKeys(String elementId, int zoomLevel, String text)  throws Exception{
        Double level = Double.valueOf((zoomLevel < 100)? zoomLevel+100: zoomLevel);
        level = level / 100;
        js.executeScript("zoomAndType('" + elementId +"', '" + String.format(Locale.ENGLISH, "%.2f", level) + "', '" +text + "')", new Object[]{ null });
        Thread.sleep(3000);
    }
    public void showInfoPanel(String message) throws Exception{
        showInfoPanel(message, 5);
    }
    public void showInfoPanel(String message, int secondes) throws Exception{
        
        js.executeScript("showSeleniumInfoPanel('" + StringEscapeUtils.escapeJavaScript(message) +"', '" + secondes * 1000 + "')", new Object[]{ null });
        Thread.sleep(secondes * 1100);
    }

    public String readPropertyOrEnv(String key, String defaultValue) {
        String v = System.getProperty(key);
        if (v == null)
            v = System.getenv(key);
        if (v == null)
            v = defaultValue;
        return v;
    }

    public String getVideoRecordingProvider() {
        URL url = getSesionNodeUrl((RemoteWebDriver) driver);
        String videoRecordingProvider = null;
        if (url != null) {
            videoRecordingProvider = "http://" + url.getHost() + ":" + url.getPort() + "/extra/GridServiecProviderServlet/";
        }
        return videoRecordingProvider;
    }

    public boolean startRecording() {
       String videoRecordingProvider = getVideoRecordingProvider();
       if (videoRecordingProvider != null && "yes".equals(videoCapture)) {
            return sendNodeRequest(videoRecordingProvider + "start");
        }
       else {
           return false;
       }
    }

    public boolean stopRecording(String videoFileName) {
        try {
            getTestVideo(videoFileName);
            return true;
        }
        catch(Exception e) {
            System.out.println("Can downlaod test video  : " + e);
            return false;
        }
    }

    public boolean getTestLogs(String videoFileName) throws Exception {
        HTMLFormatter f = new HTMLFormatter();
        File logFile = new File(OUTPUT_DIR + videoFileName + ".html");
        if (!logFile.exists()) {
            logFile.createNewFile();
        }
        FileOutputStream fos = new FileOutputStream(logFile);
        PrintStream ps = new PrintStream(fos);
        
        ps.print(f.getHead(null));
        ps.println();
        
        LogEntries entries =  driver.manage().logs().get(LogType.CLIENT);
        for(LogEntry entry : entries.getAll()) {
            if (entry.getMessage().contains("Executing:") || entry.getMessage().contains("Executed:")) {
                ps.print(f.format(entry));
                ps.println();
            }
        }
        ps.print(f.getTail(null));
        ps.println();
        ps.close();
        return true;
    }

    public boolean sendNodeRequest(String url) {
        try {
            System.out.println("call video service provider at url: " + url);
            URL obj = new URL(url);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("GET");
            int responseCode = con.getResponseCode();
            if (200 == responseCode) {
            }
            else {
                System.out.println("video recording provider reponse does not match expected value [HTTP 200]. it was :[HTTP " + responseCode + "]");
            }
            con.disconnect();
            return true;
        }
        catch(Exception e) {
            System.out.println("Can start/stop recording check taht video recording provider url is correct ad the service is running : " + e);
        }
        return false;
    }
    public void getTestVideo(String videoFileName ) throws IOException{
        String videoRecordingProvider = getVideoRecordingProvider();
        if (videoRecordingProvider == null || !"yes".equals(videoCapture)) {
            return ;
        }
        URL url = new URL(videoRecordingProvider + "save/" + videoFileName);
        System.out.println("call video service provider at url: " + videoRecordingProvider + "save/" + videoFileName);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        int responseCode = con.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
 
            InputStream inputStream = con.getInputStream();
             
            // opens an output stream to save into file
            FileOutputStream outputStream = new FileOutputStream(new File(OUTPUT_DIR + videoFileName + ".avi"));
 
            int bytesRead = -1;
            byte[] buffer = new byte[16384];
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
 
            outputStream.close();
            inputStream.close();
 
            System.out.println("File downloaded");
        } else {
            System.out.println("No file to download. Server replied HTTP code: " + responseCode);
        }
        con.disconnect();
    }

    public class HTMLFormatter extends java.util.logging.Formatter {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        public String format(LogEntry entry) {
            String message = "<tr><td>" + format.format(entry.getTimestamp()) + "</td><td>";
            if (entry.getMessage().contains("Executing:")) {
                message = message + entry.getMessage().substring(entry.getMessage().indexOf("Executing:")) ;
            }
            if (entry.getMessage().contains("Executed:")) {
                message = message + entry.getMessage().substring(entry.getMessage().indexOf("Executed:")) ;
            }
             message = message + "</td><td>" + entry.getLevel() + "</td></tr>\n";
            
            return message;
          }
        public String getHead(Handler h) {
          return ("<html>\n  <body>\n" + 
                  "<style>.logTable {    margin:0px;padding:0px;     width:100%;     box-shadow: 10px 10px 5px #888888;  border:1px solid #000000;   -moz-border-radius-bottomleft:0px;  -webkit-border-bottom-left-radius:0px;  border-bottom-left-radius:0px;  -moz-border-radius-bottomright:0px;     -webkit-border-bottom-right-radius:0px;     border-bottom-right-radius:0px;     -moz-border-radius-topright:0px;    -webkit-border-top-right-radius:0px;    border-top-right-radius:0px;    -moz-border-radius-topleft:0px;     -webkit-border-top-left-radius:0px;     border-top-left-radius:0px; }.logTable table{     border-collapse: collapse;         border-spacing: 0;    width:100%;     height:100%;    margin:0px;padding:0px; }.logTable tr:last-child td:last-child {   -moz-border-radius-bottomright:0px;     -webkit-border-bottom-right-radius:0px;     border-bottom-right-radius:0px; } .logTable table tr:first-child td:first-child {  -moz-border-radius-topleft:0px;     -webkit-border-top-left-radius:0px;     border-top-left-radius:0px; } .logTable table tr:first-child td:last-child {   -moz-border-radius-topright:0px;    -webkit-border-top-right-radius:0px;    border-top-right-radius:0px; }.logTable tr:last-child td:first-child{  -moz-border-radius-bottomleft:0px;  -webkit-border-bottom-left-radius:0px;  border-bottom-left-radius:0px; }.logTable tr:hover td{ } .logTable tr:nth-child(odd){ background-color:#aad4ff; } .logTable tr:nth-child(even)    { background-color:#ffffff; }.logTable td{    vertical-align:middle;  border:1px solid #000000;   border-width:0px 1px 1px 0px;   text-align:left;    padding:7px;    font-size:17px;     font-family:Arial;  font-weight:normal;     color:#000000; }.logTable tr:last-child td{    border-width:0px 1px 0px 0px; }.logTable tr td:last-child{     border-width:0px 0px 1px 0px; }.logTable tr:last-child td:last-child{  border-width:0px 0px 0px 0px; } .logTable tr:first-child td{       background:-o-linear-gradient(bottom, #005fbf 5%, #003f7f 100%);    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #005fbf), color-stop(1, #003f7f) );    background:-moz-linear-gradient( center top, #005fbf 5%, #003f7f 100% );    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#005fbf', endColorstr='#003f7f');  background: -o-linear-gradient(top,#005fbf,003f7f);     background-color:#005fbf;   border:0px solid #000000;   text-align:center;  border-width:0px 0px 1px 1px;   font-size:18px;     font-family:Arial;  font-weight:bold;   color:#ffffff; } .logTable tr:first-child:hover td{    background:-o-linear-gradient(bottom, #005fbf 5%, #003f7f 100%);    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #005fbf), color-stop(1, #003f7f) );    background:-moz-linear-gradient( center top, #005fbf 5%, #003f7f 100% );    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#005fbf', endColorstr='#003f7f');  background: -o-linear-gradient(top,#005fbf,003f7f);     background-color:#005fbf; } .logTable tr:first-child td:first-child{   border-width:0px 0px 1px 0px; } .logTable tr:first-child td:last-child{    border-width:0px 0px 1px 1px; }</style>"
                  +"<div class=\"logTable\"><Table>\n<tr><th width=\"20%\">Time</th><th width=\"70%\">Log Message</th><th width=\"10%\">LEVEL</th></tr>\n");
        }

        public String getTail(Handler h) {
          return ("</table></div>\n</body>\n</html>");
        }
        public String format(LogRecord record) { return ""; }
    }
    private URL getSesionNodeUrl(RemoteWebDriver remoteDriver) {
        URL hostFound = null;
        try {
            HttpCommandExecutor sessionExcuter = (HttpCommandExecutor) remoteDriver.getCommandExecutor();
            HttpHost host = new HttpHost(sessionExcuter.getAddressOfRemoteServer().getHost(), sessionExcuter.getAddressOfRemoteServer().getPort());
            BasicHttpEntityEnclosingRequest request = new BasicHttpEntityEnclosingRequest( "POST", new URL("http://" + sessionExcuter.getAddressOfRemoteServer().getHost() + ":" + sessionExcuter.getAddressOfRemoteServer().getPort() + "/grid/api/testsession?session=" + remoteDriver.getSessionId()).toExternalForm());
            HttpResponse response = new DefaultHttpClient().execute(host, request);
            URL myURL = new URL(new JSONObject(EntityUtils.toString(response.getEntity())).getString("proxyId"));
            if ((myURL.getHost() != null) && (myURL.getPort() != -1)) {
                hostFound = myURL;
            }
        } catch (Exception e) {
            
        }
        return hostFound;
    }
    protected void sendKeys(By by, String text) {
        WebElement waitFor = waitElementPresenceAndVisibility(by);
        waitFor.clear();
        waitFor.sendKeys(text);
    }
    protected void typeIn(WebDriver driver, By by, String text) {
        WebElement element = waitElementPresenceAndVisibility(by);
        element.clear();
        element.sendKeys(text);
    }
    protected void selectByVisibleText(By by, String text) {
        Select clickThis = new Select(waitElementPresenceAndVisibility(by));
        clickThis.selectByVisibleText(text);
    }
    protected void click(By by) {
        waitElementPresenceAndVisibility(by).click();
    }
    protected WebElement waitElementPresenceAndVisibility(By by) {
        WebElement element = driverWait.until(ExpectedConditions.presenceOfElementLocated(by));
        driverWait.until(ExpectedConditions.visibilityOf(element));
        return element;
    }
    protected String getText(By by) {
        return waitElementPresenceAndVisibility(by).getText();
    }

}
