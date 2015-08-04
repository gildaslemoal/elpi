package org.ofbiz.testtools.webdriverTests.utils;


import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.net.URL;
import java.util.List;
import java.util.Properties;

import org.openqa.selenium.By;
//import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
//import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class Utils {

    public static URL fromResource(String resource, ClassLoader loader) {
        URL url = null;
        loader = Thread.currentThread().getContextClassLoader();
        if (loader == null) {
            try {
                loader = Thread.currentThread().getContextClassLoader();
            } catch (SecurityException e) {
                Utils utilConfig = new Utils();
                loader = utilConfig.getClass().getClassLoader();
            }
        }
        if (url == null) url = loader.getResource(resource);
        if (url == null) url = loader.getResource(resource + ".properties");

        if (url == null) url = ClassLoader.getSystemResource(resource);
        if (url == null) url = ClassLoader.getSystemResource(resource + ".properties");
        if (url == null) url = fromFilename(resource);
        return url;
    }

    public static URL fromFilename(String filename) {
        if (filename == null) return null;
        File file = new File(filename);
        URL url = null;

        try {
            if (file.exists()) url = file.toURI().toURL();
        } catch (java.net.MalformedURLException e) {
            e.printStackTrace();
            url = null;
        }
        return url;
    }

    public static Properties getProperty(String resource){
        Properties properties = new Properties();
 
        try{
            URL url = fromResource(resource, null);

            if (url == null)
                return null;
            properties = getProperties(url);
            //Retrieve property
        }
        catch (Exception e){
            System.out.println(e.toString());
            return null;
        }
        return properties;
    }

    public static Properties getProperties(URL url) {
        if (url == null) {
            return null;
        }
        Properties properties = null;
        try {
            properties = new Properties();
            properties.load(url.openStream());
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        if (properties == null) {
            System.out.println("[UtilProperties.getProperties] could not find resource: " + url);
            return null;
        }
        return properties;
    }

    public static String getPropertyValue(String resource, String value){
        String propertyValue = "";
        try{
            Properties property = getProperty(resource);
            if (property != null) {
                //Retrieve property value
                propertyValue = property.getProperty(value);
            }
        }
        catch (Exception e){
            System.out.println(e.toString());
            return e.toString();
        }
        return propertyValue;
    }

    public static String getPropertyValue(String resource, String name, String defaultValue) {
        String value = getPropertyValue(resource, name);
        if (value == null || value.length() <= 0)
            return defaultValue;
        else
            return value;
    }
    public static boolean isElementPresent(By by, WebDriver driver) {
        try {
            driver.findElement(by);
            return true;
        } catch (NoSuchElementException e) {
            return false;
        }
    }

    /**
     * Connection to example, Check if already in Bluelight theme and english language, if not call testChangeLanguage to change
     * Most of the time, this method is not used because Bluelight theme is no more in "stable" revision, so default theme is now tomawak 
     * @param baseUrl
     * @param driver
     * @throws Exception
     */
    public static void checkAndPutExampleBluelightEnglish(String baseUrl, WebDriver driver) throws Exception {
        WebDriverWait driverWait = new WebDriverWait(driver, 30);
        WebElement waitFor;
        boolean themeAndLanguageCorrect, firstTime;
        firstTime=true;
        int i = 2;
        do {
            themeAndLanguageCorrect = false;
            driver.get(baseUrl + "example/control/logout");
            waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name("USERNAME")));
            waitFor.clear();
            waitFor.sendKeys("admin");
            WebElement element = driver.findElement(By.name("PASSWORD"));
            element.clear();
            element.sendKeys("ofbiz");
            driver.findElement(By.cssSelector("input[type=\"submit\"]")).click();
            driverWait.until(ExpectedConditions.titleContains("OFBiz: Example: Find Example"));
            List<WebElement> currentLanguages = driver.findElements(By.xpath("//ul[@id='preferences-menu']/li[3]/a"));
            if (currentLanguages.size() == 0 || ! currentLanguages.get(0).getText().contains("Language : English") ) {
                Utils.testChangeLanguage(baseUrl, null, null, "BLUELIGHT", driver);
                themeAndLanguageCorrect = true;
                i -= 1;
                firstTime = i>0;
            }
        } while (themeAndLanguageCorrect && firstTime);
        assertTrue(firstTime);

    }
    
    /**
     * connection on component and put on the theme and the language
     * @param baseUrl
     * @param component
     * @param language
     * @param theme
     * @param driver
     * @throws Exception
     */
    public static void testChangeLanguage(String baseUrl, String component,String language, String theme, WebDriver driver) throws Exception {
        WebDriverWait driverWait = new WebDriverWait(driver, 30);

        //Connection
        if (language == null) {
                    language = "English    -    [en]";
                }
        if (theme == null) {
                    theme = "BLUELIGHT";
                }
        if (component == null) {
                    component = "catalog";
        }
        driver.get(baseUrl + component +"/control/logout");
        if("webtools".equals(component)) {
            driver.get(baseUrl + component + "/control/checkLogin");
        }
        WebElement waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("input[type=\"submit\"]")));
        WebElement element = driver.findElement(By.name("USERNAME"));
        element.clear();
        element.sendKeys("admin");
        
        element = driver.findElement(By.name("PASSWORD"));
        element.clear();
        element.sendKeys("ofbiz");
        waitFor.click();
        /* Test to resolve the 501 error, but it seem  better to use driverWait.until for each field you want to clear or to sendKeys
        ExpectedCondition<Boolean> pageLoadCondition = new
                ExpectedCondition<Boolean>() {
                    public Boolean apply(WebDriver driver) {
                        return ((JavascriptExecutor)driver).executeScript("return document.readyState").equals("complete");
                    }
                };
        driverWait.until(pageLoadCondition);
        */
        Thread.sleep(500);
        //if the Preferences menu is available in the current theme
        if(isElementPresent(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"), driver)) {
            driver.findElement(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a")).click();
            driverWait.until(ExpectedConditions.elementToBeClickable(By.id("theme"))).click();

            //wait until the theme menu is displayed then select the right theme (multi menu)
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"javascript:document.SetUserPreferences_"+theme+".submit()\"]")));
            waitFor.click();
        }

        //if there is no Preferences menu in the current theme
        else {
            driver.get(baseUrl + component+"/control/ListVisualThemes");
            //Select the right theme
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"javascript:document.SetUserPreferences_"+theme+".submit()\"]")));
            waitFor.click();
        }

        //Selection of the chosen component
        waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/main\"]")));
        waitFor.click();

        //Language selection
        if(isElementPresent(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"), driver)) {
            driver.findElement(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a")).click();
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.id("language")));
            waitFor.click();
        } else {
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/ListLocales\"]")));
            waitFor.click();
        }
        //Wait until the language selection menu is displayed and chose english
        waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.linkText(language)));
        waitFor.click();

        //Logout
        //driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/logout\"]"))).click();
    }

    /**
     * connexion to webtools component to be able to call multiple removeWithWebtool method
     */
    static public void connexionToWebtools(String baseUrl, WebDriverWait driverWait, WebDriver driver)  throws Exception {
            String language = "English    -    [en]";
            String theme = "TOMAHAWK";
            String component = "webtools";
        // connexion to webtools
        driver.get(baseUrl + "webtools/control/logout");
        driver.get(baseUrl + "webtools/control/checkLogin");
        WebElement waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name("USERNAME")));
        WebElement we = null;
        waitFor.clear();
        waitFor.sendKeys("admin");
        WebElement element = driver.findElement(By.name("PASSWORD"));
        element.clear();
        element.sendKeys("ofbiz");
        waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("input[type='submit']")));
        waitFor.click();
        driverWait.until(ExpectedConditions.titleContains("OFBiz: Web Tools: Web Tools Main Page"));
        if(isElementPresent(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"), driver)) {
            we = driver.findElement(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"));
            we.click();
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.id("theme")));
            waitFor.click();

            //wait until the theme menu is displayed then select the right theme (multi menu)
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"javascript:document.SetUserPreferences_"+theme+".submit()\"]")));
            waitFor.click();
        }

        //if there is no Preferences menu in the current theme
        else
        {
            driver.get(baseUrl + "webtools/control/ListVisualThemes");
            //Select the right theme
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"javascript:document.SetUserPreferences_"+theme+".submit()\"]")));
            waitFor.click();
        }

        //Selection of the chosen component
        waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/main\"]")));
        waitFor.click();
        Thread.sleep(500);

        //Language selection
        if(isElementPresent(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"), driver)) {
            we = driver.findElement(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"));
            we.click();
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.id("language")));
            waitFor.click();
        } else {
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/ListLocales\"]")));
            waitFor.click();
        }
        //Wait until the language selection menu is displayed and chose english
        waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.linkText(language)));
        waitFor.click();
    }
    
    /**
     * Change only the theme and language without connecting
     */
    public static void changeThemeLanguage(String baseUrl, String component, String language, String theme, WebDriver driver)  throws Exception {
        WebDriverWait driverWait = new WebDriverWait(driver, 30);

        if (language == null) {
                    language = "English    -    [en]";
                }
        if (theme == null) {
                    theme = "TOMAHAWK";
                }
        WebElement waitFor;
        WebElement we;
        if(isElementPresent(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"), driver)) {
            we = driver.findElement(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"));
            we.click();
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.id("theme")));
            waitFor.click();

            //wait until the theme menu is displayed then select the right theme (multi menu)
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"javascript:document.SetUserPreferences_"+theme+".submit()\"]")));
            waitFor.click();
        }

        //if there is no Preferences menu in the current theme
        else
        {
            driver.get(baseUrl + component + "/control/ListVisualThemes");
            //Select the right theme
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"javascript:document.SetUserPreferences_"+theme+".submit()\"]")));
            waitFor.click();
        }

        //Selection of the chosen component
        waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/main\"]")));
        waitFor.click();
        Thread.sleep(500);

        //Language selection
        if(isElementPresent(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"), driver)) {
            we = driver.findElement(By.xpath("//div[@id=\"controls\"]//span[@id=\"prefBtn\"]//a"));
            we.click();
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.id("language")));
            waitFor.click();
        } else {
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.xpath("//a[@href=\"/"+component+"/control/ListLocales\"]")));
            waitFor.click();
        }
        //Wait until the language selection menu is displayed and chose english
        waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.linkText(language)));
        waitFor.click();
    }

    /**
     * Open findEntity, do find for value and click on delete and check there is no error message
     * @param baseUrl
     * @param driverWait
     * @param driver
     * @param entity
     * @param pkId
     * @param value
     * @throws Exception
     */
    static public void removeOneWithWebtools(String baseUrl, WebDriverWait driverWait, WebDriver driver, 
            String entity, String pkId, String value )  throws Exception {
        // open find for Entity
        driver.get(baseUrl + "webtools/control/FindGeneric?entityName="+entity);
        driverWait.until(ExpectedConditions.titleContains("OFBiz: Web Tools: Find Values For Entity: "+entity));
        WebElement waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name(pkId)));
        waitFor.clear();
        waitFor.sendKeys(value);
        if (isElementPresent(By.cssSelector("input[type='submit']"), driver)) {
            WebElement we = driver.findElement(By.cssSelector("input[type='submit']"));
            we.click();
            driverWait.until(ExpectedConditions.invisibilityOfElementLocated(By.name(pkId)));
            waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.xpath("//div[@id='search-results']//tr[2]//a[.='Delete']")));
            waitFor.click();
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.linkText("BACK TO FIND SCREEN")));
            waitFor.click();
            driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name(pkId)));
            assertEquals("OFBiz: Web Tools: Find Values For Entity: "+entity, driver.getTitle());
            assertTrue(driver.findElements(By.xpath("//div[@class='content-messages errorMessage']")).size()==0); 
        }
   }

    /**
     * remove all value with pkId=value
     * Open findEntity, iterate on do find for value and if delete button exist click on it and check there is no error message
     * @param baseUrl
     * @param driverWait
     * @param driver
     * @param entity
     * @param pkId
     * @param value
     * @throws Exception
     */
    static public void removeMultipleWithWebtools(String baseUrl, WebDriverWait driverWait, WebDriver driver, 
            String entity, String pkId, String value )  throws Exception {
    	removeMultipleWithWebtools(baseUrl, driverWait, driver, null, null, entity, pkId, value);
   }
    
    /**
     * remove all value with pkId1=value1 and pkId2=value2
     * Open findEntity, iterate on do find for value1 and value2 and if delete button exist click on it and check there is no error message
     * @param baseUrl
     * @param driverWait
     * @param driver
     * @param pkId1
     * @param value1
     * @param entity
     * @param pkId2
     * @param value2
     * @throws Exception
     */
    static public void removeMultipleWithWebtools(String baseUrl, WebDriverWait driverWait, WebDriver driver, 
    		String pkId1, String value1, String entity, String pkId2, String value2 )  throws Exception {
        
    	// open find for Entity
        driver.get(baseUrl + "webtools/control/FindGeneric?entityName="+entity);
        driverWait.until(ExpectedConditions.titleContains("OFBiz: Web Tools: Find Values For Entity: "+entity));
        if (pkId1!=null) {
        	WebElement waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name(pkId1)));
        	waitFor.clear();
        	waitFor.sendKeys(value1);
        }
        WebElement waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name(pkId2)));
        waitFor.clear();
        waitFor.sendKeys(value2);
        WebElement we = driver.findElement(By.cssSelector("input[type='submit']"));
        we.click();
        driverWait.until(ExpectedConditions.invisibilityOfElementLocated(By.name(pkId2)));
        while (driver.findElements(By.xpath("//div[@id='search-results']//tr[2]//a[.='Delete']")).size()!=0) {
            we = driver.findElement(By.xpath("//div[@id='search-results']//tr[2]//a[.='Delete']"));
            we.click();
            driverWait.until(ExpectedConditions.titleContains("OFBiz: Web Tools: View Value: "+entity));
            assertTrue(driver.findElements(By.xpath("//div[@class='content-messages errorMessage']")).size()==0); 
            waitFor = driverWait.until(ExpectedConditions.elementToBeClickable(By.linkText("BACK TO FIND SCREEN")));
            waitFor.click();
            driverWait.until(ExpectedConditions.titleContains("OFBiz: Web Tools: Find Values For Entity: "+entity));
            if (pkId1!=null) {
            	waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name(pkId1)));
            	waitFor.clear();
            	waitFor.sendKeys(value1);
            }
            waitFor = driverWait.until(ExpectedConditions.presenceOfElementLocated(By.name(pkId2)));
            waitFor.clear();
            waitFor.sendKeys(value2);
            we = driver.findElement(By.cssSelector("input[type='submit']"));
            we.click();
        }
   }
}
