const jwt = require('jsonwebtoken');
const axios = require('axios');
const FormData = require('form-data');

async function testUpload() {
  const token = jwt.sign({ id: 1, phone: '1234567890', role: 'member' }, 'super_secret_jwt_key_123', { expiresIn: '24h' });
  
  const form = new FormData();
  form.append('recordType', 'LAB_REPORT');
  form.append('recordDate', new Date().toISOString());
  form.append('doctorName', 'Test Doctor');
  // No file for now
  
  try {
    const response = await axios.post('http://localhost:5000/api/medical-records/upload', form, {
      headers: {
        ...form.getHeaders(),
        'Authorization': `Bearer ${token}`
      }
    });
    console.log('Success:', response.data);
  } catch (error) {
    console.log('Error status:', error.response ? error.response.status : error.message);
    console.log('Error data:', error.response ? error.response.data : '');
  }
}

testUpload();
