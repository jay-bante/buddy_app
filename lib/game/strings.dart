class LocalText {
  final String en, hi, mr;
  const LocalText(this.en, this.hi, this.mr);
  String inLanguage(String code) =>
      code == 'hi'
          ? hi
          : code == 'mr'
          ? mr
          : en;
}

String tr(String key, String lang) => uiText[key]!.inLanguage(lang);
const uiText = <String, LocalText>{
  'app': LocalText('Wildwood Trail', 'वन यात्रा', 'वनवाट'),
  'home': LocalText('Home', 'होम', 'मुख्यपृष्ठ'),
  'journey': LocalText('Journey', 'यात्रा', 'प्रवास'),
  'journal': LocalText('Journal', 'डायरी', 'नोंदवही'),
  'settings': LocalText('Settings', 'सेटिंग्स', 'सेटिंग्ज'),
  'welcome': LocalText(
    'Ready for the wild?',
    'वन के लिए तैयार?',
    'वनात जायला तयार?',
  ),
  'subtitle': LocalText(
    'A new trail. A wiser you.',
    'नई राह। नई समझ।',
    'नवी वाट. नवी समज.',
  ),
  'choose': LocalText(
    'Choose your explorer',
    'अपना खोजी चुनें',
    'तुमचा प्रवासी निवडा',
  ),
  'profileNote': LocalText(
    'Question style, not a test of your age.',
    'यह प्रश्नों की शैली है, उम्र की परीक्षा नहीं।',
    'ही प्रश्नांची शैली आहे, वयाची परीक्षा नाही.',
  ),
  'child': LocalText('Child', 'बच्चे', 'मुले'),
  'young': LocalText('Young', 'युवा', 'तरुण'),
  'adult': LocalText('Adult', 'वयस्क', 'प्रौढ'),
  'older': LocalText('Older adult', 'वरिष्ठ', 'ज्येष्ठ'),
  'childDetail': LocalText('Simple stories', 'सरल कहानियाँ', 'सोप्या गोष्टी'),
  'youngDetail': LocalText(
    'Friends & choices',
    'दोस्त और निर्णय',
    'मित्र आणि निर्णय',
  ),
  'adultDetail': LocalText(
    'Plan & prioritise',
    'योजना और प्राथमिकता',
    'नियोजन आणि प्राधान्य',
  ),
  'olderDetail': LocalText(
    'Perspective & judgement',
    'अनुभव और विवेक',
    'अनुभव आणि विवेक',
  ),
  'difficulty': LocalText('Your challenge', 'अपनी चुनौती', 'तुमचे आव्हान'),
  'low': LocalText('Low', 'आसान', 'सोपे'),
  'medium': LocalText('Medium', 'मध्यम', 'मध्यम'),
  'high': LocalText('High', 'कठिन', 'कठीण'),
  'lowDetail': LocalText(
    'Recognise the safer choice.',
    'सुरक्षित विकल्प पहचानें।',
    'सुरक्षित पर्याय ओळखा.',
  ),
  'mediumDetail': LocalText(
    'Compare risks and priorities.',
    'जोखिम और प्राथमिकताएँ तुलना करें।',
    'धोके आणि प्राधान्ये तपासा.',
  ),
  'highDetail': LocalText(
    'Weigh evidence and trade-offs.',
    'जानकारी और विकल्पों को परखें।',
    'माहिती आणि पर्यायांचा विचार करा.',
  ),
  'play': LocalText('Start exploring', 'यात्रा शुरू करें', 'प्रवास सुरू करा'),
  'resume': LocalText(
    'Continue journey',
    'यात्रा जारी रखें',
    'प्रवास पुढे चालू ठेवा',
  ),
  'newJourney': LocalText(
    'Start a new journey',
    'नई यात्रा शुरू करें',
    'नवा प्रवास सुरू करा',
  ),
  'chapter': LocalText('Chapter', 'अध्याय', 'टप्पा'),
  'checkpoint': LocalText('Decision point', 'निर्णय स्थल', 'निर्णय बिंदू'),
  'zone0': LocalText('Emerald Grove', 'हरित उपवन', 'हिरवे उपवन'),
  'zone1': LocalText('Bamboo Bend', 'बाँस का मोड़', 'बांबूचे वळण'),
  'zone2': LocalText('River Watch', 'नदी का किनारा', 'नदीकाठ'),
  'zone3': LocalText('Fern Valley', 'फर्न की घाटी', 'नेच्यांची दरी'),
  'zone4': LocalText('Canopy Ridge', 'हरित शिखर', 'हिरवी टेकडी'),
  'zone5': LocalText('Ranger Haven', 'वनरक्षक पड़ाव', 'वनरक्षक तळ'),
  'longTrail': LocalText(
    '6 chapters · 12 decisions · branching routes',
    '6 अध्याय · 12 निर्णय · अलग रास्ते',
    '6 टप्पे · 12 निर्णय · वेगवेगळ्या वाटा',
  ),
  'offline': LocalText('Offline adventure', 'ऑफलाइन रोमांच', 'ऑफलाइन साहस'),
  'xp': LocalText('XP', 'अनुभव', 'अनुभव'),
  'correct': LocalText('Correct', 'सही', 'बरोबर'),
  'missed': LocalText('Missed', 'चूके', 'चुकलेले'),
  'best': LocalText('Best streak', 'लगातार सही', 'सलग बरोबर'),
  'emptyJournal': LocalText(
    'Your first discovery is waiting.',
    'आपकी पहली खोज इंतज़ार कर रही है।',
    'तुमचा पहिला शोध वाट पाहत आहे.',
  ),
  'language': LocalText('App language', 'ऐप की भाषा', 'अॅपची भाषा'),
  'languageNote': LocalText(
    'Menus, questions and explanations change together.',
    'मेनू, प्रश्न और समझाइश एक साथ बदलेंगे।',
    'मेनू, प्रश्न आणि स्पष्टीकरण एकत्र बदलतील.',
  ),
  'sound': LocalText('Sound effects', 'ध्वनि', 'ध्वनी'),
  'haptics': LocalText('Haptic feedback', 'कंपन', 'कंपन'),
  'lightweight': LocalText(
    'Lightweight effects',
    'हल्के दृश्य प्रभाव',
    'हलके दृश्य परिणाम',
  ),
  'largeText': LocalText('Larger text', 'बड़ा अक्षर आकार', 'मोठी अक्षरे'),
  'privacy': LocalText(
    'No account or birth date. Your chosen profile stays on this device.',
    'कोई खाता या जन्मतिथि नहीं। चुनी प्रोफ़ाइल इसी डिवाइस में रहती है।',
    'खाते किंवा जन्मतारीख नाही. निवडलेली प्रोफाइल याच डिव्हाइसवर राहते.',
  ),
  'help': LocalText('How to play', 'कैसे खेलें', 'कसे खेळावे'),
  'helpBody': LocalText(
    'Walk to the marked decision points. A tiger circles while you answer. You have 15 seconds. Correct: +20 XP. Wrong or timeout: −10 XP. Reach the camp after two decisions to choose your next route.',
    'चिह्नित निर्णय स्थलों तक चलें। उत्तर देते समय बाघ चक्कर लगाता है। आपके पास 15 सेकंड हैं। सही: +20 अनुभव। गलत या समय समाप्त: −10 अनुभव। दो निर्णयों के बाद पड़ाव पहुँचकर अगला रास्ता चुनें।',
    'चिन्हांकित निर्णय बिंदूपर्यंत चाला. उत्तर देताना वाघ फेऱ्या मारतो. तुमच्याकडे 15 सेकंद आहेत. बरोबर: +20 अनुभव. चूक किंवा वेळ संपली: −10 अनुभव. दोन निर्णयांनंतर तळावर पोहोचा आणि पुढची वाट निवडा.',
  ),
  'safety': LocalText(
    'Fictional learning game, not survival training. Follow local forest officials. Real tiger safari areas may prohibit walking.',
    'यह काल्पनिक सीखने का खेल है, जीवित बचने का प्रशिक्षण नहीं। स्थानीय वन अधिकारियों की बात मानें। असली बाघ सफारी क्षेत्रों में पैदल चलना निषिद्ध हो सकता है।',
    'हा काल्पनिक शिकण्याचा खेळ आहे, जीव वाचवण्याचे प्रशिक्षण नाही. स्थानिक वन अधिकाऱ्यांचे निर्देश पाळा. खऱ्या व्याघ्र सफारी क्षेत्रात चालण्यास बंदी असू शकते.',
  ),
  'previewNote': LocalText(
    'Browser demo: temporary session; Android-only audio, haptics and saves.',
    'ब्राउज़र डेमो: अस्थायी सत्र; ध्वनि, कंपन और सेव केवल Android में।',
    'ब्राउझर डेमो: तात्पुरते सत्र; ध्वनी, कंपन आणि सेव्ह फक्त Android मध्ये.',
  ),
  'continue': LocalText('Continue', 'आगे बढ़ें', 'पुढे चला'),
  'back': LocalText('Back', 'वापस', 'मागे'),
  'cancel': LocalText('Cancel', 'रद्द करें', 'रद्द करा'),
  'changeTitle': LocalText(
    'Begin a fresh journey?',
    'नई यात्रा शुरू करें?',
    'नवा प्रवास सुरू करायचा?',
  ),
  'changeBody': LocalText(
    'Changing explorer or difficulty resets the route. Your XP and journal stay.',
    'खोजी या कठिनाई बदलने से रास्ता रीसेट होगा। अनुभव और डायरी सुरक्षित रहेंगे।',
    'प्रवासी किंवा काठिण्य बदलल्यास वाट पुन्हा सुरू होईल. अनुभव आणि नोंदवही कायम राहतील.',
  ),
  'locked': LocalText(
    'Complete the previous chapter',
    'पिछला अध्याय पूरा करें',
    'आधीचा टप्पा पूर्ण करा',
  ),
  'done': LocalText('Completed', 'पूरा हुआ', 'पूर्ण झाले'),
  'current': LocalText(
    'Your current trail',
    'आपकी वर्तमान राह',
    'तुमची सध्याची वाट',
  ),
  'pause': LocalText('Take a breath', 'थोड़ा विश्राम', 'थोडी विश्रांती'),
  'returnHome': LocalText('Return to lobby', 'होम पर जाएँ', 'मुख्यपृष्ठावर जा'),
  'explore': LocalText('Move', 'चलें', 'चाला'),
  'observe': LocalText('Observe', 'ध्यान दें', 'निरीक्षण'),
  'observeNote': LocalText(
    'Follow the glowing marker. Use the map to navigate around water. No weapon is needed: decisions are your tools.',
    'चमकते निशान की ओर जाएँ। पानी से बचने के लिए नक्शा देखें। हथियार नहीं, आपके निर्णय ही आपके साधन हैं।',
    'चमकत्या खुणेकडे जा. पाणी टाळण्यासाठी नकाशा पाहा. शस्त्र नको; तुमचे निर्णय हीच साधने आहेत.',
  ),
  'camp': LocalText('Reach the camp', 'पड़ाव तक पहुँचें', 'तळावर पोहोचा'),
  'target': LocalText('Follow the marker', 'निशान की ओर चलें', 'खुणेकडे चाला'),
  'encounter': LocalText('Tiger encounter', 'बाघ से सामना', 'वाघाशी सामना'),
  'decision': LocalText('Think it through', 'सोचकर चुनें', 'विचार करून निवडा'),
  'seconds': LocalText('SEC', 'सेकंड', 'सेकंद'),
  'reward': LocalText('+20 correct', '+20 सही', '+20 बरोबर'),
  'penalty': LocalText(
    '−10 wrong / timeout',
    '−10 गलत / समय समाप्त',
    '−10 चूक / वेळ संपली',
  ),
  'goodTitle': LocalText(
    'A thoughtful choice.',
    'समझदारी भरा निर्णय।',
    'विचारपूर्वक निवड.',
  ),
  'wrongTitle': LocalText(
    'Learn for the next trail.',
    'अगली राह के लिए सीखें।',
    'पुढच्या वाटेसाठी शिका.',
  ),
  'timeoutTitle': LocalText('Time ran out.', 'समय समाप्त।', 'वेळ संपली.'),
  'better': LocalText('The better choice', 'बेहतर विकल्प', 'योग्य पर्याय'),
  'tigerNote': LocalText(
    'The tiger circles while you decide.',
    'निर्णय लेते समय बाघ चक्कर लगाता है।',
    'निर्णय घेताना वाघ फेऱ्या मारतो.',
  ),
  'routeTitle': LocalText(
    'Your next route',
    'आपका अगला रास्ता',
    'तुमची पुढची वाट',
  ),
  'routeBody': LocalText(
    'Both routes are authorised in this fictional forest. Choose a direct path or a longer observation loop. The choice changes where you walk.',
    'इस काल्पनिक वन में दोनों रास्ते अनुमत हैं। सीधा रास्ता या लंबा निरीक्षण मार्ग चुनें। आपकी पसंद से यात्रा की दिशा बदलेगी।',
    'या काल्पनिक वनात दोन्ही वाटा अधिकृत आहेत. थेट वाट किंवा लांब निरीक्षण फेरी निवडा. निवडीनुसार चालण्याची दिशा बदलेल.',
  ),
  'direct': LocalText('Ranger path', 'वनरक्षक मार्ग', 'वनरक्षक वाट'),
  'directDetail': LocalText(
    'A direct walk between checkpoints',
    'निर्णय स्थलों के बीच सीधी राह',
    'निर्णय बिंदूंमधील थेट वाट',
  ),
  'loop': LocalText('Canopy loop', 'हरित परिक्रमा', 'हिरवी फेरी'),
  'loopDetail': LocalText(
    'A longer route via the far clearing',
    'दूर के खुले स्थान से लंबा रास्ता',
    'दूरच्या मोकळ्या जागेतून लांब वाट',
  ),
  'finishTitle': LocalText(
    'The forest remembers.',
    'वन को याद रहेगा।',
    'वनाला आठवण राहील.',
  ),
  'finishBody': LocalText(
    'You reached all six camps and resolved twelve decisions. Start again with a new explorer or challenge.',
    'आप छह पड़ावों तक पहुँचे और बारह निर्णय लिए। नए खोजी या चुनौती के साथ फिर शुरू करें।',
    'तुम्ही सहा तळांवर पोहोचलात आणि बारा निर्णय घेतलेत. नवा प्रवासी किंवा आव्हान निवडून पुन्हा सुरू करा.',
  ),
  'map': LocalText('Trail map', 'राह का नक्शा', 'वाटेचा नकाशा'),
  'mapLegend': LocalText(
    'White: you • Gold: destination • Orange: tiger',
    'सफेद: आप • सुनहरा: गंतव्य • नारंगी: बाघ',
    'पांढरे: तुम्ही • सोनेरी: गंतव्य • नारिंगी: वाघ',
  ),
  'trail': LocalText('TRAIL', 'राह', 'वाट'),
  'saveError': LocalText(
    'Local save unavailable. You can still play.',
    'स्थानीय सेव उपलब्ध नहीं। आप खेल सकते हैं।',
    'स्थानिक सेव्ह उपलब्ध नाही. तरीही खेळता येईल.',
  ),
  'timerNote': LocalText(
    '15 seconds. The timer continues if you leave the app.',
    '15 सेकंड। ऐप छोड़ने पर भी समय चलता रहेगा।',
    '15 सेकंद. अॅप सोडल्यावरही वेळ चालू राहील.',
  ),
  'journeyProgress': LocalText(
    'Decisions reached',
    'निर्णय पूरे',
    'निर्णय पूर्ण',
  ),
};
