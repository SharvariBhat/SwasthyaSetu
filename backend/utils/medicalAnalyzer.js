/**
 * Simple Medical Text Analyzer
 * Analyzes extracted text to find diseases, medicines, and abnormal values
 */

const analyzeMedicalText = (text) => {
  const lowercaseText = text.toLowerCase();
  
  const results = {
    diseases: [],
    medicines: [],
    abnormalValues: [],
    severity: 'Low',
    followUpSuggestions: 'Keep maintaining a healthy lifestyle. Consult a doctor if you feel any discomfort.'
  };

  // Common diseases to search for
  const diseaseKeywords = [
    'diabetes', 'hypertension', 'anemia', 'fever', 'asthma', 'cholesterol', 
    'thyroid', 'infection', 'allergy', 'pneumonia', 'bronchitis'
  ];

  diseaseKeywords.forEach(disease => {
    if (lowercaseText.includes(disease)) {
      results.diseases.push(disease.charAt(0).toUpperCase() + disease.slice(1));
    }
  });

  // Common medicines to search for
  const medicineKeywords = [
    'paracetamol', 'metformin', 'insulin', 'aspirin', 'amoxicillin', 
    'ibuprofen', 'cetirizine', 'atorvastatin', 'levothyroxine', 'omeprazole'
  ];

  medicineKeywords.forEach(medicine => {
    if (lowercaseText.includes(medicine)) {
      results.medicines.push(medicine.charAt(0).toUpperCase() + medicine.slice(1));
    }
  });

  // Simple logic for abnormal values
  if (lowercaseText.includes('high') || lowercaseText.includes('elevated') || lowercaseText.includes('low') || lowercaseText.includes('abnormal')) {
    results.abnormalValues.push('One or more values appear to be outside the normal range');
    results.severity = 'Medium';
    results.followUpSuggestions = 'We found some abnormal values. It is recommended to schedule a follow-up appointment with your doctor for a detailed discussion.';
  }

  // Increase severity if multiple issues found
  if (results.diseases.length > 2 || results.medicines.length > 3) {
    results.severity = 'High';
    results.followUpSuggestions = 'Multiple health indicators detected. Please seek professional medical consultation as soon as possible.';
  }

  return results;
};

module.exports = {
  analyzeMedicalText
};
