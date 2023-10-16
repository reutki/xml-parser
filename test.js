function findTextSubstring(text, searchTerm) {
    const index = text.indexOf(searchTerm);
    if (index !== -1) {
      return `Text found at index ${index}`;
    } else {
      return "Text not found";
    }
  }
  
  const text = "This is a sample text for demonstration.";
  const searchTerm = "for";
  console.log(findTextSubstring(text, searchTerm));
  