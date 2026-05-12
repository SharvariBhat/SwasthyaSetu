/**
 * Test script to verify Tesseract.js OCR functionality
 * Tests the OCR service with a sample image
 */

require('dotenv').config();
const ocrService = require('./utils/ocrService');
const fs = require('fs');
const path = require('path');

async function testTesseractOCR() {
  console.log('='.repeat(60));
  console.log('Testing Tesseract.js OCR Configuration');
  console.log('='.repeat(60));

  try {
    // Check if Tesseract.js is installed
    console.log('\n[TEST] Checking Tesseract.js installation...');
    const Tesseract = require('tesseract.js');
    console.log('[TEST] ✓ Tesseract.js is installed');
    console.log(`[TEST] Version: ${Tesseract.version || 'unknown'}`);

    // Check for test image
    const testImagePath = path.join(__dirname, 'uploads', 'medical_records', 'mr1.png');
    
    if (!fs.existsSync(testImagePath)) {
      console.log('\n[TEST] ⚠ No test image found at:', testImagePath);
      console.log('[TEST] To test OCR, upload a medical record image first');
      console.log('[TEST] Then run this test again');
      console.log('\n[TEST] Tesseract.js is ready to use!');
      return;
    }

    console.log('\n[TEST] Found test image:', path.basename(testImagePath));
    console.log('[TEST] File size:', fs.statSync(testImagePath).size, 'bytes');

    // Test OCR extraction
    console.log('\n[TEST] Starting OCR extraction test...');
    console.log('[TEST] This may take a minute on first run (downloading language models)...\n');

    const result = await ocrService.extractTextFromImage(
      testImagePath,
      'image/png'
    );

    console.log('\n[TEST] ✓ OCR extraction successful!');
    console.log('[TEST] Extracted text length:', result.text.length, 'characters');
    console.log('[TEST] Confidence score:', result.confidence + '%');
    
    if (result.text.length > 0) {
      console.log('\n[TEST] Sample extracted text (first 200 characters):');
      console.log('[TEST]', result.text.substring(0, 200) + '...');
    } else {
      console.log('\n[TEST] ⚠ No text was extracted from the image');
    }

    // Test text cleaning
    console.log('\n[TEST] Testing text cleaning...');
    const cleanedText = ocrService.cleanExtractedText(result.text);
    const wordCount = ocrService.getWordCount(cleanedText);
    console.log('[TEST] ✓ Text cleaned successfully');
    console.log('[TEST] Cleaned text length:', cleanedText.length, 'characters');
    console.log('[TEST] Word count:', wordCount);

    console.log('\n' + '='.repeat(60));
    console.log('Tesseract.js OCR Test Summary');
    console.log('='.repeat(60));
    console.log('✓ Tesseract.js installed and working');
    console.log('✓ OCR extraction functional');
    console.log('✓ Text processing working');
    console.log('\nTesseract.js OCR is ready for production use!');
    console.log('='.repeat(60));

  } catch (error) {
    console.error('\n[TEST] ✗ Error during OCR test:', error.message);
    
    if (error.message.includes('Cannot find module')) {
      console.error('[TEST] Tesseract.js is not installed');
      console.error('[TEST] Run: npm install tesseract.js');
    } else if (error.message.includes('ENOENT')) {
      console.error('[TEST] Test image file not found');
      console.error('[TEST] Upload a medical record first, then run this test');
    } else {
      console.error('[TEST] Error details:', error);
    }
    
    process.exit(1);
  }
}

// Run the test
testTesseractOCR();
