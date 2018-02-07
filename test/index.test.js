import assert from 'assert';
import fs from 'fs';
import path from 'path';
import Vinyl from 'vinyl';
import riot from '../src/';

function createVinyl(fileName) {
  const filePath = path.join(__dirname, 'fixtures', 'input', fileName);

  return new Vinyl({
    cwd: __dirname,
    base: path.join(__dirname, 'fixtures', 'input'),
    path: filePath,
    contents: fs.readFileSync(filePath)
  });
}

function getExpected(fileName) {
  const filePath = path.join(__dirname, 'fixtures', 'expected', fileName);
  return fs.readFileSync(filePath, 'utf8').replace(/\r\n/g, '\n');
}

describe('gulp-riot', function() {
  it('should compile riot tag files', function(done) {
    const stream = riot();

    stream.once('data', function(file) {
      assert(file.isBuffer());
      assert.equal(file.relative, 'sample1.js');
      assert.equal(file.contents.toString(), getExpected('sample1.js'));
      done();
    });

    stream.write(createVinyl('sample1.tag'));
  });

  it('should apply compile options', function(done) {
    const stream = riot({ compact: true });

    stream.once('data', function(file) {
      assert.equal(file.contents.toString(), getExpected('sample2.js'));
      done();
    });

    stream.write(createVinyl('sample2.tag'));
  });

  it('should rename `.jade` extension to `.js`', function(done) {
    const stream = riot();

    stream.once('data', function(file) {
      assert.equal(file.extname, '.js');
      assert.equal(file.contents.toString(), getExpected('sample3.js'));
      done();
    });

    stream.write(createVinyl('sample3.jade'));
  });

  it('should match cli output when type: none', function(done) {
    const stream = riot({ type: 'none' });

    stream.once('data', function(file) {
      assert.equal(file.contents.toString(), getExpected('sample1.js'));
      done();
    });

    stream.write(createVinyl('sample1.tag'));
  });

  it('should match modular options output', function(done) {
    const stream = riot({ modular: true });

    stream.once('data', function(file) {
      assert.equal(file.contents.toString(), getExpected('sample4.js'));
      done();
    });

    stream.write(createVinyl('sample4.tag'));
  });

  it('should return error when compile failed', function(done) {
    const stream = riot({ type: 'nonescript' });

    stream.on('error', function(error) {
      assert.equal(error.plugin, 'gulp-riot');
      done();
    });

    stream.write(createVinyl('sample1.tag'));
  });

  it('should compile with custom css parser', function(done) {
    const stream = riot({
      parsers: {
        css: {
          myparser: function(tag, css) {
            return css.replace(/@tag/, tag);
          }
        }
      }
    });

    stream.once('data', function(file) {
      assert.equal(file.contents.toString(), getExpected('sample5.js'));
      done();
    });

    stream.write(createVinyl('sample5.tag'));
  });

  it('should compile with custom js parser', function(done) {
    const stream = riot({
      parsers: {
        js: {
          myparser: function(js) {
            return js.replace(/@version/, '1.0.0');
          }
        }
      }
    });

    stream.once('data', function(file) {
      assert.equal(file.contents.toString(), getExpected('sample6.js'));
      done();
    });

    stream.write(createVinyl('sample6.tag'));
  });

  it('should compile with whitespace option', function(done) {
    const stream = riot({ whitespace: true });

    stream.once('data', function(file) {
      assert.equal(file.contents.toString(), getExpected('sample7.js'));
      done();
    });

    stream.write(createVinyl('sample7.tag'));
  });
});
