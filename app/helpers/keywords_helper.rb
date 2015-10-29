module KeywordsHelper
  def keywordKindOptions
    [['未定義', GLOBAL_VAR['KEYWORD_UNDEFINED']],
     ['產地鮮果', GLOBAL_VAR['KEYWORD_FRUITS']],
     ['新鮮時蔬', GLOBAL_VAR['KEYWORD_VEGETABLES']],     
     ['米麵雜糧', GLOBAL_VAR['KEYWORD_GRAINS']],    
     ['小農手作', GLOBAL_VAR['KEYWORD_PROCESSED']]]
  end  
end  