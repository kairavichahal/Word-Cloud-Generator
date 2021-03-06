//Kairavi Chahal | kchahal
//Project 2 | December 17, 2013
 
//Copyright Kairavi Chahal | 2013 | Carnegie Mellon University
//All rights reserved.

//WORD CLOUD GENERATOR
//Give it your own text in a file named "words.txt" in the data folder.
//'S' to save word cloud; 'R' to reload another file; 'Q' to quit.

//Explores IntDict & StringList functionality in Processing.

//TO IMPLEMENT: Choose "boring" word threshold.

String[] data, words, uniqueWords;
//"Boring" words:
String[] commonWordsArray = {"the", "be", "to", "of", "and", "a", "in", "that", "have", "i",
                             "it", "for", "not", "on", "with", "he", "as", "you", "do", "at",
                             "this", "but", "his", "by", "from", "they", "we", "say", "her",
                             "she", "or", "an", "will", "my", "one", "all", "would", "there",
                             "their", "what", "so", "up", "out", "if", "about", "who", "get", 
                             "which", "go", "me", "when", "make", "can", "like", "time", "no",
                             "just", "him", "know", "take", "people", "into", "year", "your",
                             "good", "some", "could", "them", "see", "other", "than", "then",
                             "now", "look", "only", "come", "its", "over", "think", "also",
                             "back", "after", "use", "two", "how", "our", "work", "first",
                             "well", "way", "even", "new", "want", "because", "any", "these",
                             "give", "day", "most", "us", "find", "tell", "ask", "seem", "feel",
                             "try", "leave", "call", "beneath", "under", "above", "is", "are"};
StringList commonWordsList;
IntDict wordFreqs;
int saves = 0;
//int threshold = 15; //Default. Draws 15 most unique words. Can change with slider.
//int[][] placedWords;

void setup() {
  //Adjust size to fit cloud.
  size(displayWidth, displayHeight-48);
  //Ask user to select a file to generate a word cloud.
//  selectInput("SELECT .TXT FILE FOR WORD CLOUD GENERATOR:", "loadData");

//  placedWords = create2DArray(width, height);
  
  data = loadStrings("data/words.txt");
  
  commonWordsList = stringArrayToStringList(commonWordsArray);
  words = createWordArray(data); //array of all words in data lowercase, sorted
  uniqueWords = getUniqueWords(words); //array of unique words
  wordFreqs = getFreqs(words, uniqueWords); //frequency of each word
//  println(wordFreqs);
  //Sorted array leads to large-to-small word cloud. 
//  wordFreqs.sortValuesReverse();
//  println(wordFreqs);
  drawWordCloud(wordFreqs);
}

void loadData(File selection) {
  textAlign(CENTER);
  if (selection == null) {
    background(255); text("No file selected.", width/2, height/2);
  } else {
    data = loadStrings(selection);
    background(255); text("Generating word cloud for: " + selection.getAbsolutePath(), width/2, height/2);
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    String saveAs = "WordCloud_" + saves + ".png";
    saveFrame(saveAs);
    println("Saved as: " + saveAs);
    saves++;
  }
  if (key == 'r' || key == 'R') {
    background(255);
    selectInput("SELECT .TXT FILE FOR WORD CLOUD GENERATOR:", "loadData");
  }
  if (key == 'q' || key == 'Q') {
    exit();
  }
}

String[] createWordArray(String[] data) {
  //Code from mergeLines() in "cc23.pde" by Jim Roberts.
  String oneLine = "";
  for (int i=0; i<data.length; i++) {
    oneLine += data[i].toLowerCase() + " ";
  }
  //Original code below:
  //Remove all punctuation and numerals.  
  String[] wordArray = splitTokens(oneLine, "0123456789`~!@#$%^&*()-=_+[]\\{}|;':\"<>?,./ ");
  return sort(wordArray);
}

String[] getUniqueWords(String[] words) {
  StringList wordsList = new StringList();
  for (int i=0; i<words.length; i++) {
    wordsList.append(words[i]);
  }
  return wordsList.getUnique();
}

StringList stringArrayToStringList(String[] array) {
  StringList list = new StringList();
  for (int i=0; i<array.length; i++) {
    list.append(array[i]);
  }
  return list;
}

IntDict getFreqs(String[] allWords, String[] uniqueWords) {
  IntDict dict = new IntDict();
  for (int i=0; i<allWords.length; i++) {
    if (!commonWordsList.hasValue(words[i])) {
      if (dict.hasKey(allWords[i])) {
        dict.add(allWords[i], 1);
      } else {
        dict.set(allWords[i], 1);
      }
    }
  }
  return dict;
}

void drawWordCloud(IntDict freq) {
  String[] values = freq.keyArray();
  int[] keys = freq.valueArray();
  int scale = max(keys);
  float lineLength = 0;
  int lineNumber = 0;
  float w = 20; float h = 20; float hmax = 0;
  float x = 20; float y = 0;
  textAlign(LEFT, TOP);
  for (int i=0; i<keys.length; i++) {
    if (keys[i] > 1) {
      textSize(scale*log(keys[i])); fill(color(random(200), random(200), random(200)));
    } else {
      textSize(scale*log(1.9)); fill(color(random(200), random(200), random(200)));
    }
    
    if (h >= hmax) {
      hmax = h;
    }
    
    x = w + 20;
    lineLength += x;
    if (lineLength > width-w) {
      lineLength = 0;
      y = y + hmax;
      hmax = 0; x = 20;
    }
    
    text(values[i], lineLength, y);
    w = textWidth(values[i]);
    h = textAscent() + textDescent();
  }
}

//int[][] create2DArray(int ncols, int nrows) {
//  int[][] array = new int[ncols][nrows];
//  for (int i=0; i<ncols; i++) {
//    for (int j=0; j<nrows; j++) {
//      array[i][j] = 0;
//    }
//  }
//  return array;
//}
//
//void placeWord(float x, float y, float w, float h) {
//  for (int i=floor(x); i<=floor(x)+ceil(w); i++) {
//    for (int j=ceil(y); j<=ceil(y)+ceil(h); j++) {
//      placedWords[i][j] = 1;
//    }
//  }
//}
//
//boolean wordPlaced(float x, float y, float w, float h) {
//  for (int i=floor(x); i<floor(x)+ceil(w); i++) {
//    for (int j=ceil(y); j<ceil(y)+ceil(h); j++) {
//      if ((i < width && j < height) && placedWords[i][j] == 1) {
//        return true;
//      }
//    }
//  }
//  return false;
//}
//
//int[] findPosition(float w, float h) {
//  int[] xy = new int[2];
//  for (int i=0; i<width; i++) {
//    for (int j=0; j<height; j++) {
//      if (!wordPlaced(i, j, w, h)) {
//        xy[0] = i; xy[1] = j;
//      }
//    }
//  }
//  return null;
//}
