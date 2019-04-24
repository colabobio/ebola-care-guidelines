package org.broadinstitute.ebola_care_guidelines;

import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import com.github.barteksc.pdfviewer.PDFView;
import com.github.barteksc.pdfviewer.listener.OnLoadCompleteListener;
import com.github.barteksc.pdfviewer.listener.OnPageChangeListener;
import com.github.barteksc.pdfviewer.listener.OnPageErrorListener;
import com.github.barteksc.pdfviewer.scroll.DefaultScrollHandle;
//import com.github.barteksc.pdfviewer.util.FitPolicy;
import com.shockwave.pdfium.PdfDocument;

import java.util.List;

// To show pdfs inside an android view:
// https://github.com/barteksc/AndroidPdfViewer
public class PDFViewActivity extends AppCompatActivity implements
    OnPageChangeListener, OnLoadCompleteListener, OnPageErrorListener {

  final static public String VIEW_TITLE = "view_title";
  final static public String PAGE_NUMBER = "page_number";
  final static public String PDF_FILE = "pdf_file";

  private static final String TAG = PDFViewActivity.class.getSimpleName();

  private PDFView pdfView;

  private String viewTitle;
  private String pdfFileName;
  private Integer pageNumber;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_pdf);

    if (savedInstanceState == null) {
      Bundle extras = getIntent().getExtras();
      if (extras == null) {
        viewTitle = "No file fount";
        pdfFileName = "";
        pageNumber = 0;
      } else {
        viewTitle = extras.getString(VIEW_TITLE);
        pdfFileName = extras.getString(PDF_FILE);
        pageNumber = extras.getInt(PAGE_NUMBER);
      }
    } else {
      viewTitle = (String) savedInstanceState.getSerializable(VIEW_TITLE);
      pdfFileName = (String) savedInstanceState.getSerializable(PDF_FILE);
      pageNumber = (Integer) savedInstanceState.getSerializable(PAGE_NUMBER);
    }

    pdfView = findViewById(R.id.pdfView);
    pdfView.setBackgroundColor(Color.LTGRAY);
    displayFromAsset(pdfFileName);
    setTitle(viewTitle);
  }

  private void displayFromAsset(String assetFileName) {
    pdfFileName = assetFileName;

    pdfView.fromAsset(pdfFileName)
        .defaultPage(pageNumber)
        .onPageChange(this)
        .enableAnnotationRendering(true)
        .onLoad(this)
        .scrollHandle(new DefaultScrollHandle(this))
        .spacing(10) // in dp
        .onPageError(this)
//                .pageFitPolicy(FitPolicy.BOTH)
        .load();
  }

  @Override
  public void onPageChanged(int page, int pageCount) {
    pageNumber = page;
    setTitle(String.format("%s %s / %s", viewTitle, page + 1, pageCount));
  }

  @Override
  public void loadComplete(int nbPages) {
    PdfDocument.Meta meta = pdfView.getDocumentMeta();
    Log.e(TAG, "title = " + meta.getTitle());
    Log.e(TAG, "author = " + meta.getAuthor());
    Log.e(TAG, "subject = " + meta.getSubject());
    Log.e(TAG, "keywords = " + meta.getKeywords());
    Log.e(TAG, "creator = " + meta.getCreator());
    Log.e(TAG, "producer = " + meta.getProducer());
    Log.e(TAG, "creationDate = " + meta.getCreationDate());
    Log.e(TAG, "modDate = " + meta.getModDate());
    printBookmarksTree(pdfView.getTableOfContents(), "-");
  }

  public void printBookmarksTree(List<PdfDocument.Bookmark> tree, String sep) {
    for (PdfDocument.Bookmark b : tree) {

      Log.e(TAG, String.format("%s %s, p %d", sep, b.getTitle(), b.getPageIdx()));

      if (b.hasChildren()) {
        printBookmarksTree(b.getChildren(), sep + "-");
      }
    }
  }

  @Override
  public void onPageError(int page, Throwable t) {
    Log.e(TAG, "Cannot load page " + page);
  }
}
