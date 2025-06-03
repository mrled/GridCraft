/* JavaScript code for the web view
 */


/* Set the configuration global variable from the gridcraft-config JSON script element
 */
function setConfig() {
  const configElement = document.getElementById('gridcraft-config');
  if (!configElement) {
    console.error('Configuration element not found.');
    return;
  }
  window.GridCraftConfig = JSON.parse(configElement.textContent);
}

/* Call setConfig() once
 */
setConfig()

/* Toggle the 'selected' class on an element with the given keyId
 *
 * This will show a visual indication that the element has been selected.
 * Apply the animationDuration from the configuration.
 * (This is applied here and not part of CSS so that it can be configured by the GridCraft.Configuration module.)
 */
function toggleSelected(keyId) {
  const element = document.getElementById(keyId);
  if (!element) {
    console.error(`Element with ID ${keyId} not found.`);
    return;
  }
  const config = getConfig();
  if (!config) {
    console.error('Configuration not found.');
    return;
  }
  element.classList.add('selected');
  element.style.animationDuration = `${config.animationMs}ms`;
  setTimeout(() => element.classList.remove('selected'), config.animationMs);
}
