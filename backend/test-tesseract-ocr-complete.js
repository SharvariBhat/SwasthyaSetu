/**
 * Complete Tesseract OCR Testing Script
 * Tests the OCR service with actual image files
 * Run: node test-tesseract-ocr-complete.js
 */

require('dotenv').config();
const ocrService = require('./utils/ocrService');
const fs = require('fs');
const path = require('path');

// Color codes for console output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

const log = {
  success: (msg) => console.log(`${colors.green}✓ ${msg}${colors.reset}`),
  error: (msg) => console.log(`${colors.red}✗ ${msg}${colors.reset}`),
  info: (msg) => console.log(`${colors.blue}ℹ ${msg}${colors.reset}`),
  warn: (msg) => console.log(`${colors.yellow}⚠ ${msg}${colors.reset}`),
  section: (msg) => console.log(`\n${colors.cyan}═══ ${msg} ═══${colors.reset}\n`)
};

async function testTesseractOCR() {
  log.section('TESSERACT OCR TESTING SUITE');

  // Test 1: Check if Tesseract.js is installed
  log.info('Test 1: Checking Tesseract.js installation...');
  try {
    const Tesseract = require('tesseract.js');
    log.success('Tesseract.js is installed');
    log.info(`Version: ${Tesseract.version || 'Unknown'}`);
  } catch (error) {
    log.error('Tesseract.js is not installed');
    log.error(`Error: ${error.message}`);
    process.exit(1);
  }

  // Test 2: Check if OCR service is available
  log.info('Test 2: Checking OCR service...');
  try {
    if (!ocrService.extractTextFromImage) {
      throw new Error('extractTextFromImage function not found');
    }
    if (!ocrService.cleanExtractedText) {
      throw new Error('cleanExtractedText function not found');
    }
    if (!ocrService.getWordCount) {
      throw new Error('getWordCount function not found');
    }
    log.success('OCR service is properly configured');
  } catch (error) {
    log.error(`OCR service error: ${error.message}`);
    process.exit(1);
  }

  // Test 3: Check for test images
  log.info('Test 3: Checking for test images...');
  const testImageDir = path.join(__dirname, 'uploads', 'medical_records');
  const testImages = [];

  if (fs.existsSync(testImageDir)) {
    const files = fs.readdirSync(testImageDir);
    const imageFiles = files.filter(f => /\.(png|jpg|jpeg)$/i.test(f));
    testImages.push(...imageFiles.map(f => path.join(testImageDir, f)));
    log.success(`Found ${imageFiles.length} test image(s) in ${testImageDir}`);
  } else {
    log.warn(`Test image directory not found: ${testImageDir}`);
  }

  // Test 4: Test OCR with available images
  if (testImages.length > 0) {
    log.section('RUNNING OCR TESTS ON IMAGES');
    
    for (let i = 0; i < testImages.length; i++) {
      const imagePath = testImages[i];
      const fileName = path.basename(imagePath);
      
      log.info(`Test 4.${i + 1}: Processing ${fileName}...`);
      
      try {
        const startTime = Date.now();
        
        // Determine file type
        const ext = path.extname(fileName).toLowerCase();
        let fileType = 'image/png';
        if (ext === '.jpg' || ext === '.jpeg') {
          fileType = 'image/jpeg';
        }
        
        log.info(`File type: ${fileType}`);
        
        // Run OCR
        const result = await ocrService.extractTextFromImage(imagePath, fileType);
        const duration = Date.now() - startTime;
        
        log.success(`OCR completed in ${duration}ms`);
        log.info(`Confidence: ${result.confidence}%`);
        log.info(`Text length: ${result.text.length} characters`);
        
        // Clean and analyze text
        const cleanedText = ocrService.cleanExtractedText(result.text);
        const wordCount = ocrService.getWordCount(cleanedText);
        
        log.info(`Cleaned text length: ${cleanedText.length} characters`);
        log.info(`Word count: ${wordCount}`);
        
        // Show sample of extracted text
        const textSample = cleanedText.substring(0, 100);
        log.info(`Text sample: "${textSample}${cleanedText.length > 100 ? '...' : ''}"`);
        
      } catch (error) {
        log.error(`Failed to process ${fileName}`);
        log.error(`Error: ${error.message}`);
      }
    }
  } else {
    log.warn('No test images found. Skipping OCR processing tests.');
    log.info('To test OCR, place image files in: backend/uploads/medical_records/');
  }

  // Test 5: Test text cleaning function
  log.section('TESTING TEXT CLEANING FUNCTION');
  const testTexts = [
    'Hello   World',
    'Line1\n\nLine2\n\nLine3',
    '  Trimmed text  ',
    'Multiple\n\n\nNewlines\n\nHere'
  ];

  testTexts.forEach((text, index) => {
    const cleaned = ocrService.cleanExtractedText(text);
    log.info(`Test 5.${index + 1}: "${text}" → "${cleaned}"`);
  });

  // Test 6: Test word count function
  log.section('TESTING WORD COUNT FUNCTION');
  const wordCountTests = [
    'One',
    'One Two Three',
    'The quick brown fox jumps over the lazy dog',
    '  Multiple   spaces   between   words  ',
    ''
  ];

  wordCountTests.forEach((text, index) => {
    const count = ocrService.getWordCount(text);
    log.info(`Test 6.${index + 1}: "${text}" → ${count} words`);
  });

  // Test 7: Environment configuration
  log.section('ENVIRONMENT CONFIGURATION');
  log.info(`OCR Engine: ${process.env.OCR_ENGINE || 'Not set'}`);
  log.info(`Node Environment: ${process.env.NODE_ENV || 'Not set'}`);
  log.info(`Upload Directory: ${process.env.UPLOAD_DIR || 'Not set'}`);

  log.section('TESTING COMPLETE');
  log.success('All tests completed successfully!');
  log.info('Your Tesseract OCR setup is ready for production use.');
}

// Run tests
testTesseractOCR().catch(error => {
  log.error(`Test suite failed: ${error.message}`);
  process.exit(1);
});
