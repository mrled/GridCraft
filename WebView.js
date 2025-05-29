function toggleSelected(keyId) {
  const element = document.getElementById(keyId);
  if (!element) {
    console.error(`Element with ID ${keyId} not found.`);
    return;
  }
  element.classList.add('selected');
  setTimeout(() => element.classList.remove('selected'), 100);
}