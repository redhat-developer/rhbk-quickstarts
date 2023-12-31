package org.keycloak.quickstart;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author <a href="mailto:bruno@abstractj.org">Bruno Oliveira</a>
 */
public class ClientPage {

    @FindBy(name = "logoutBtn")
    private WebElement logoutButton;

    @FindBy(linkText = "Administration")
    private WebElement adminLink;

    @FindBy(linkText = "User Premium")
    private WebElement premiumLink;

    @FindBy(linkText = "Dynamic Menu")
    private WebElement dynamicMenuLink;

    @FindBy(tagName = "h2")
    private WebElement message;

    public void clickAdminLink() {
        adminLink.click();
    }

    public void clickPremiumLink() {
        premiumLink.click();
    }

    public void clickDynamicMenuLink() {
        dynamicMenuLink.click();
    }

    public void clickLogout() {
        logoutButton.click();
    }

    public String getMessage() {
        return message.getText();
    }
}
