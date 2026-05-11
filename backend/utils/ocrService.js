const Tesseract = require('tesseract.js');
const fs = require('fs');
const path = require('path');

/**
 * OCR Service using Tesseract.js
 * Provides text extraction from images (PNG, JPG, JPEG)
 */

/**
 * Extract text from an image file using Tesseract OCR
 * @param {string} filePath - Path to the image file
 * @param {string} fileType - MIME type of the file
 * @returns {Promise<{text: string, confidence: number}>} Extracted text and confidence score
 */
const extractTextFromImage = async (filePath, fileType) => {
  try {
    // Validate file exists
    if (!fs.existsSync(filePath)) {
      throw new Error(`File not found: ${filePath}`);
    }

    // Validate file type
    const supportedTypes = ['image/png', 'image/jpeg', 'image/jpg'];
    if (!supportedTypes.includes(fileType)) {
      throw new Error(`Unsupported file type: ${fileType}. Supported types: PNG, JPG, JPEG`);
    }

    console.log(`[OCR] Starting text extraction from: ${path.basename(filePath)}`);
    console.log(`[OCR] File type: ${fileType}`);

    // Initialize Tesseract worker
    const worker = await Tesseract.createWorker();

    console.log('[OCR] Tesseract worker initialized');

    // Perform OCR
    console.log('[OCR] Starting text recognition...');
    const result = await worker.recognize(filePath, 'eng');

    // Extract text and confidence
    const extractedText = result.data.text;
    const confidence = result.data.confidence;

    console.log(`[OCR] Text extraction completed`);
    console.log(`[OCR] Confidence score: ${confidence}%`);
    console.log(`[OCR] Extracted text length: ${extractedText.length} characters`);

    // Terminate worker to free resources
    await worker.terminate();
    console.log('[OCR] Tesseract worker terminated');

    return {
      text: extractedText,
      confidence: confidence
    };
  } catch (error) {
    console.error('[OCR] Error during text extraction:', error.message);
    throw error;
  }
};

/**
 * Clean and normalize extracted text
 * @param {string} text - Raw extracted text
 * @returns {string} Cleaned text
 */
const cleanExtractedText = (text) => {
  if (!text) return '';

  return text
    .replace(/\n+/g, ' ')      // Replace multiple newlines with single space
    .replace(/\s+/g, ' ')      // Replace multiple spaces with single space
    .trim();                    // Remove leading/trailing whitespace
};

/**
 * Calculate word count from text
 * @param {string} text - Text to analyze
 * @returns {number} Word count
 */
const getWordCount = (text) => {
  if (!text || !text.trim()) return 0;
  return text.trim().split(/\s+/).length;
};

module.exports = {
  extractTextFromImage,
  cleanExtractedText,
  getWordCount
};
